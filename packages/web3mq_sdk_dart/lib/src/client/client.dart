import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:pointycastle/api.dart' as pointycastle;
import 'package:rxdart/rxdart.dart';
import 'package:web3mq/src/api/contacts.api.dart';
import 'package:web3mq/src/api/cyber_service.dart';
import 'package:web3mq/src/api/requests.dart';
import 'package:web3mq/src/api/responses.dart' as web3mq;
import 'package:web3mq/src/api/user_api.dart';
import 'package:web3mq/src/api/web3mq_service.dart';
import 'package:web3mq/src/client/persistence_client.dart';
import 'package:web3mq/src/error/error.dart';
import 'package:web3mq/src/models/accounts.dart';
import 'package:web3mq/src/models/channel_state.dart';
import 'package:web3mq/src/models/cyber_user_follow_status.dart';
import 'package:web3mq/src/utils/cyber_signing_key_storage.dart';
import 'package:web3mq/src/utils/sign_text_factory.dart';
import 'package:web3mq/src/utils/utils.dart';
import 'package:web3mq/src/ws/models/pb/message.pb.dart';
import 'package:web3mq/src/ws/models/ws_models.dart';
import 'package:web3mq/src/ws/websocket.dart';

import '../api/responses.dart';
import '../http/http_client.dart';
import '../models/cyber_profile.dart';
import '../models/pagination.dart';
import '../utils/logger.dart';
import '../utils/signer.dart';
import '../utils/wallet_connector.dart';
import 'client_state.dart';

part 'client_chat.dart';
part 'client_contacts.dart';
part 'client_group.dart';
part 'client_notification.dart';
part 'client_topic.dart';
part 'client_user.dart';

// /// Handler function used for logging records. Function requires a single
// /// [LogRecord] as the only parameter.
// typedef LogHandlerFunction = void Function(LogRecord record);

// final _levelEmojiMapper = {
//   Level.INFO: 'ℹ️',
//   Level.WARNING: '⚠️',
//   Level.SEVERE: '🚨',
// };

class Web3MQClient {
  Web3MQClient(String apiKey,
      {this.logLevel = Level.ALL,
      this.logHandlerFunction = Web3MQLogger.defaultLogHandler,
      String? baseURL,
      Duration connectTimeout = const Duration(seconds: 15),
      Duration receiveTimeout = const Duration(seconds: 15),
      Web3MQService? apiService,
      CyberService? cyberService,
      Web3MQWebSocket? ws,
      Signer? signer,
      WalletConnector? wc}) {
    logger.info('Initiating new Client');

    final options = Web3MQHttpClientOptions(
        baseUrl: baseURL,
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout);

    _service = apiService ??
        Web3MQService(
          apiKey,
          options: options,
          logger: detachedLogger('🕸️'),
        );

    _cyberService = cyberService;

    _ws = ws ??
        Web3MQWebSocket(
          apiKey: apiKey,
          baseUrl: options.baseUrl,
          handler: handleEvent,
          logger: detachedLogger('🔌'),
        );

    _apiKey = apiKey;

    _signer = signer ?? Signer.instance;

    walletConnector = wc;

    state = ClientState(this, _signer);
  }

  late final String _apiKey;

  /// By default the Chat client will write all messages with level Warn or
  /// Error to stdout.
  late final Web3MQWebSocket _ws;

  ///
  late final Web3MQService _service;

  ///
  CyberService? _cyberService;

  ///
  late final Signer _signer;

  ///
  WalletConnector? walletConnector;

  /// This client state
  late ClientState state;

  /// Additional headers for all requests
  static Map<String, Object?> additionalHeaders = {};

  PersistenceClient? _originalPersistenceClient;

  /// Chat persistence client
  // ignore: unnecessary_getters_setters
  PersistenceClient? get persistenceClient => _persistenceClient;

  PersistenceClient? _persistenceClient;

  /// Whether the chat persistence is available or not
  bool get persistenceEnabled => _persistenceClient != null;

  set persistenceClient(PersistenceClient? value) {
    _originalPersistenceClient = value;
  }

  final _eventController = BehaviorSubject<Event>();

  /// Stream of [Event] coming from [_ws] connection
  /// Listen to this or use the [on] method to filter specific event types
  Stream<Event> get _eventStream => _eventController.stream;

  /// Method called to add a new event to the [_eventController].
  void handleEvent(Event event) {
    switch (event.type) {
      case EventType.notificationMessageNew:
        final notifications = event.notifications;
        if (notifications != null && notifications.isNotEmpty) {
          _notificationController.add(notifications);
        }
        break;
      case EventType.connectionChanged:
        state.currentNodeId = event.nodeId;
        break;
      case EventType.messageNew:
        final wsMessage = event.message;
        if (null == wsMessage) return;
        final message = Message.fromWSMessage(wsMessage)
            .copyWith(sendingStatus: MessageSendingStatus.sent);
        _newMessageController.add(message);
        break;
      default:
        break;
    }
    _eventController.add(event);
  }

  final _notificationController = BehaviorSubject<List<web3mq.Notification>>();

  ///
  Stream<List<web3mq.Notification>> get notificationStream =>
      _notificationController.stream;

  final _newMessageController = BehaviorSubject<Message>();

  /// Stream of new messages.
  Stream<Message> get newMessageStream => _newMessageController.stream;

  StreamSubscription<ConnectionStatus>? _connectionStatusSubscription;

  final _wsConnectionStatusController =
      BehaviorSubject.seeded(ConnectionStatus.disconnected);

  set _wsConnectionStatus(ConnectionStatus status) =>
      _wsConnectionStatusController.add(status);

  /// The current status value of the [_ws] connection
  ConnectionStatus get wsConnectionStatus =>
      _wsConnectionStatusController.value;

  /// This notifies the connection status of the [_ws] connection.
  /// Listen to this to get notified when the [_ws] tries to reconnect.
  Stream<ConnectionStatus> get wsConnectionStatusStream =>
      _wsConnectionStatusController.stream.distinct();

  final _queryChannelsStreams = <String, Future<List<ChannelState>>>{};

  ///
  final Level logLevel;

  late final Logger logger = detachedLogger('📡');

  final LogHandlerFunction logHandlerFunction;

  /// Default logger for the [Web3MQClient].
  Logger detachedLogger(String name) => Logger.detached(name)
    ..level = logLevel
    ..onRecord.listen(logHandlerFunction);

  /// Connects the current user, this triggers a connection to the API.
  /// It returns a [Future] that resolves when the connection is setup.
  /// Pass [connectWebSocket]: false, if you want to connect to websocket
  /// at a later stage or use the client in connection-less mode
  Future<User> connectUser(User user) => _connectUser(user);

  Future<User> _connectUser(User user) async {
    if (_ws.connectionCompleter?.isCompleted == false) {
      throw const Web3MQError(
        'User already getting connected, try calling `disconnectUser` '
        'before trying to connect again',
      );
    }

    logger.info('setting user : ${user.userId}');

    state.currentUser = user;

    _cyberService?.connect(user.userId);

    try {
      if (_originalPersistenceClient != null) {
        _persistenceClient = _originalPersistenceClient;
        await _persistenceClient!.connect(user.userId);
      }
      final connectedUser = await openConnection();
      return state.currentUser = connectedUser;
    } catch (e, stk) {
      logger.severe('error connecting user : ${user.userId}', e, stk);
      rethrow;
    }
  }

  /// Closes the [_ws] connection and resets the [state]
  Future<void> disconnectUser() async {
    logger.info('Disconnecting user : ${state.currentUser?.userId}');

    // resetting state
    state.dispose();
    state = ClientState(this, _signer);

    // closing web-socket connection
    closeConnection();
  }

  /// Creates a new WebSocket connection with the current user.
  Future<User> openConnection() async {
    assert(state.currentUser != null, 'User is not set on client');

    final user = state.currentUser!;

    logger.info('Opening web-socket connection for ${user.userId}');

    if (wsConnectionStatus == ConnectionStatus.connecting) {
      throw Web3MQError('Connection already in progress for ${user.userId}');
    }

    if (wsConnectionStatus == ConnectionStatus.connected) {
      throw Web3MQError('Connection already available for ${user.userId}');
    }

    _wsConnectionStatus = ConnectionStatus.connecting;

    // skipping `ws` seed connection status -> ConnectionStatus.disconnected
    // otherwise `client.wsConnectionStatusStream` will emit in order
    // 1. ConnectionStatus.disconnected -> client seed status
    // 2. ConnectionStatus.connecting -> client connecting status
    // 3. ConnectionStatus.disconnected -> ws seed status
    _connectionStatusSubscription =
        _ws.connectionStatusStream.skip(1).listen(_connectionStatusHandler);

    try {
      await _ws.connect(user);

      // Start listening to events
      state.subscribeToEvents();

      return user;
    } catch (e, stk) {
      logger.severe('error connecting ws', e, stk);
      rethrow;
    }
  }

  /// Disconnects the [_ws] connection,
  /// without removing the user set on client.
  ///
  /// This will not trigger default auto-retry mechanism for reconnection.
  /// You need to call [openConnection] to reconnect to [_ws].
  void closeConnection() {
    if (wsConnectionStatus == ConnectionStatus.disconnected) return;

    logger
        .info('Closing web-socket connection for ${state.currentUser?.userId}');
    _wsConnectionStatus = ConnectionStatus.disconnected;

    _connectionStatusSubscription?.cancel();
    _connectionStatusSubscription = null;

    // Stop listening to events
    state.cancelEventSubscription();

    _ws.disconnect();
  }

  void _connectionStatusHandler(ConnectionStatus status) async {
    final previousState = wsConnectionStatus;
    final currentState = _wsConnectionStatus = status;

    final event = Event(EventType.connectionChanged,
        nodeId: _ws.nodeId, connectionStatus: status);
    handleEvent(event);

    // If the client was not connected and it's now connected,
    // we want to query the channels and sync the state
    if (currentState == ConnectionStatus.connected &&
        previousState != ConnectionStatus.connected) {
      Stream<List<ChannelState>> channels = fetchChannels();
      await for (List<ChannelState> _ in channels) {}
      if (persistenceEnabled) {
        await sync();
      }
    }
  }

  /// Call this function to dispose the clients
  Future<void> dispose() async {
    logger.info('Disposing new Web3MQClient');

    // disposing state
    state.dispose();

    // closing web-socket connection
    closeConnection();

    await _eventController.close();
    await _notificationController.close();
    await _newMessageController.close();
    await _wsConnectionStatusController.close();
  }

  /// Stream of [Event] coming from [_ws] connection
  /// Pass an eventType as parameter in order to filter just a type of event
  Stream<Event> on([
    String? eventType,
    String? eventType2,
    String? eventType3,
    String? eventType4,
  ]) {
    if (eventType == null) return _eventStream;
    return _eventStream.where((event) =>
        event.type == eventType ||
        event.type == eventType2 ||
        event.type == eventType3 ||
        event.type == eventType4);
  }
}
