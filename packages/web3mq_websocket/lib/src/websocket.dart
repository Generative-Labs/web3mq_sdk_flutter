import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:web3mq_websocket/src/message_signer.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

import 'channel_sender.dart';
import 'command_generator.dart';
import 'error/error.dart';
import 'models/buffer_convertible.dart';
import 'models/connection_status.dart';
import 'models/event.dart';
import 'models/message_factory.dart';
import 'models/pb/connect.pb.dart';
import 'models/pb/message.pb.dart';
import 'models/ping_message.dart';
import 'models/user.dart';
import 'timer_helper.dart';
import 'utils/keypair.dart';

typedef WebSocketChannelProvider = WebSocketChannel Function(
  Uri uri, {
  Iterable<String>? protocols,
});

enum ConnectMode {
  normal,
  bridge,
}

abstract class Web3MQWebSocket {
  /// Connects to the `web3mq` server.
  Future<Event> connect(WebSocketUser user,
      {ConnectMode mode = ConnectMode.normal});

  /// Disconnect from the `web3mq` server.
  void disconnect();

  /// This notifies of connection status changes
  Stream<ConnectionStatus> get connectionStatusStream;

  void send(Web3MQBufferConvertible message);
}

class Web3MQWebSocketManager with TimerHelper implements Web3MQWebSocket {
  /// Creates a new websocket manager
  ///
  /// To connect the WS call [connect].
  Web3MQWebSocketManager({
    this.appKey,
    required this.baseUrl,
    this.reconnectionMonitorInterval = 10,
    this.healthCheckInterval = 20,
    this.reconnectionMonitorTimeout = 40,
    Logger? logger,
    MessageSinger? signer,
    this.webSocketChannelProvider,
  })  : _logger = logger,
        _signer = signer ?? Web3MQEd25519MessageSigner();

  ///
  final String? appKey;

  /// Websocket base Url
  final String baseUrl;

  /// The logger
  final Logger? _logger;

  final MessageSinger _signer;

  /// Which signs the message.
  MessageSinger get signer => _signer;

  /// Connection function
  /// Used only for testing purpose
  final WebSocketChannelProvider? webSocketChannelProvider;

  /// Interval of the reconnection monitor timer
  /// This checks that it received a new event in the last
  /// [reconnectionMonitorTimeout] seconds, otherwise it considers the
  /// connection unhealthy and reconnects the WS
  final int reconnectionMonitorInterval;

  /// Interval of the health event sending timer
  /// This sends a health event every [healthCheckInterval] seconds in order to
  /// make the server aware that the client is still listening
  final int healthCheckInterval;

  /// The timeout that uses the reconnection monitor timer to consider the
  /// connection unhealthy
  final int reconnectionMonitorTimeout;

  /// This notifies of connection status changes
  @override
  Stream<ConnectionStatus> get connectionStatusStream =>
      _connectionStatusController.stream.distinct();

  final _connectionStatusController =
      BehaviorSubject.seeded(ConnectionStatus.disconnected);

  set _connectionStatus(ConnectionStatus status) =>
      _connectionStatusController.add(status);

  /// The current connection status value.
  ConnectionStatus get connectionStatus => _connectionStatusController.value;

  /// Flag for whether connect request is in progress.
  bool _connectRequestInProgress = false;

  final _messageController = StreamController<Web3MQRequestMessage>();

  /// Stream of messages received.
  Stream<Web3MQRequestMessage> get messageStream => _messageController.stream;

  final _messageUpdateController = StreamController<Web3MQMessageStatusResp>();

  /// Stream of message status updates received.
  Stream<Web3MQMessageStatusResp> get messageUpdateStream =>
      _messageUpdateController.stream;

  final _notificationController = StreamController<Web3MQMessageListResponse>();

  /// Stream of messages received.
  Stream<Web3MQMessageListResponse> get notificationStream =>
      _notificationController.stream;

  ///
  WebSocketChannel? _channel;

  /// The message sender.
  WebSocketUser? _user;

  DateTime? _lastEventAt;

  String? _nodeId;

  /// The node id which is returned after connection with the web3mq server.
  String? get nodeId => _nodeId;

  ///
  StreamSubscription? _webSocketChannelSubscription;

  ///
  bool _manuallyClosed = false;

  ///
  Completer<Event>? connectionCompleter;

  ConnectMode _connectMode = ConnectMode.normal;

  /// Connect the WS using the parameters passed in the constructor.
  @override
  Future<Event> connect(WebSocketUser user,
      {ConnectMode mode = ConnectMode.normal}) async {
    if (_connectRequestInProgress) {
      throw const Web3MQWebSocketError('''
        You've called connect twice,
        can only attempt 1 connection at the time,
        ''');
    }
    _connectMode = mode;
    _connectRequestInProgress = true;
    _manuallyClosed = false;

    _user = user;
    _connectionStatus = ConnectionStatus.connecting;
    connectionCompleter = Completer<Event>();

    try {
      final keyPair = KeyPair.fromPrivateKeyHex(user.sessionKey);
      await _initAndSubscribeToWebSocketChannel(
          _buildUri(), user.userId, keyPair.privateKey);
    } catch (e, stk) {
      _onConnectionError(e, stk);
    }

    return connectionCompleter!.future;
  }

  /// Disconnects the WS and releases eventual resources
  @override
  void disconnect() {
    if (connectionStatus == ConnectionStatus.disconnected) return;

    _resetRequestFlags(resetAttempts: true);

    _connectionStatus = ConnectionStatus.disconnected;

    _logger?.info('[WS] Disconnecting web-socket connection');

    _user = null;
    connectionCompleter = null;

    _stopMonitoringEvents();
    _manuallyClosed = true;
    _closeWebSocketChannel();
  }

  int _reconnectAttempt = 0;
  bool _reconnectRequestInProgress = false;

  void _reconnect() async {
    _logger?.info('Retrying connection : $_reconnectAttempt');
    final user = _user;
    if (user == null) return;
    if (_reconnectRequestInProgress) return;
    _reconnectRequestInProgress = true;

    _stopMonitoringEvents();
    // Closing any previously opened web-socket
    _closeWebSocketChannel();

    _reconnectAttempt += 1;
    _connectionStatus = ConnectionStatus.connecting;

    final delay = _getReconnectInterval(_reconnectAttempt);
    setTimer(
      Duration(milliseconds: delay),
      () async {
        final uri = _buildUri();
        try {
          final keyPair = KeyPair.fromPrivateKeyHex(user.sessionKey);
          _initAndSubscribeToWebSocketChannel(
              uri, user.userId, keyPair.privateKey);
        } catch (e, stk) {
          _onConnectionError(e, stk);
        }
      },
    );
  }

  Future<void> _initAndSubscribeToWebSocketChannel(
      Uri uri, String userId, Uint8List privateKey) async {
    final wsUrl = uri.toString();
    _logger?.info('Initiating connection with $wsUrl');
    if (_channel != null) {
      _closeWebSocketChannel();
    }
    WebSocket webSocket;
    try {
      final webSocketChannelProvider = this.webSocketChannelProvider;
      if (webSocketChannelProvider != null) {
        _channel = webSocketChannelProvider.call(uri);
      } else {
        webSocket = await WebSocket.connect(wsUrl);
        _channel = IOWebSocketChannel(webSocket);
      }
      _subscribeToWebSocketChannel();
      if (_connectMode == ConnectMode.bridge && appKey != null) {
        send(await WebSocketMessageGenerator.bridgeCommandMessage(
            appKey!, userId, privateKey, _signer));
      } else {
        send(await WebSocketMessageGenerator.connectCommandMessage(
            userId, privateKey, _signer));
      }
    } catch (error) {
      _logger?.warning('Connect Failed with ${error.toString()}');
      throw Web3MQWebSocketError.fromAnyMessage(error.toString());
    }
  }

  ///　Sends message.
  @override
  void send(Web3MQBufferConvertible message) {
    _channel?.send(message);
  }

  /// Sends text message to the given topic.
  Future<void> sendBinary(Uint8List bytes, String topic,
      {String? threadId,
      String cipherSuite = 'NONE',
      bool needStore = true,
      Map<String, String>? extraData}) async {
    final user = _user;
    final nodeId = _nodeId;
    if (user == null || nodeId == null) {
      throw Web3MQWebSocketError(
          "Send message error: you should be connected first");
    }
    final keyPair = KeyPair.fromPrivateKeyHex(user.sessionKey);
    final message = await MessageFactory.fromBytes(
        bytes, topic, user.userId, keyPair.privateKey, nodeId);
    send(message);
  }

  /// Sends text message to the given topic.
  Future<void> sendText(String text, String topic,
      {String? threadId,
      String cipherSuite = 'NONE',
      bool needStore = true,
      Map<String, String>? extraData}) async {
    final user = _user;
    final nodeId = _nodeId;
    if (user == null || nodeId == null) {
      throw Web3MQWebSocketError(
          "Send message error: you should be connected first");
    }
    final keyPair = KeyPair.fromPrivateKeyHex(user.sessionKey);
    final chatMessage = await MessageFactory.fromText(
        text, topic, user.userId, keyPair.privateKey, nodeId,
        threadId: threadId,
        needStore: needStore,
        cipherSuite: cipherSuite,
        extraData: extraData);
    send(chatMessage);
  }

  void _closeWebSocketChannel() {
    _logger?.info('[WS] Closing connection with $baseUrl');
    if (_channel != null) {
      _nodeId = null;
      _unsubscribeFromWebSocketChannel();
      _channel?.sink
          .close(_manuallyClosed ? status.normalClosure : status.goingAway);
      _channel = null;
    }
  }

  void _subscribeToWebSocketChannel() {
    _logger?.info('Started listening to $baseUrl');
    if (_webSocketChannelSubscription != null) {
      _unsubscribeFromWebSocketChannel();
    }
    _webSocketChannelSubscription = _channel?.stream.listen(
      _onDataReceived,
      onError: _onConnectionError,
      onDone: _onConnectionClosed,
    );
  }

  void _unsubscribeFromWebSocketChannel() {
    _logger?.info('Stopped listening to $baseUrl');
    if (_webSocketChannelSubscription != null) {
      _webSocketChannelSubscription?.cancel();
      _webSocketChannelSubscription = null;
    }
  }

  void _onDataReceived(dynamic data) {
    _logger?.info("[WS] on data received");
    _resetRequestFlags(resetAttempts: true);

    final bytes = data as List<int>;
    final eventType = bytes[1];
    final eventBuffer = bytes.sublist(2, bytes.length);

    final commandType = WSCommandType.fromCode(eventType);
    _lastEventAt = DateTime.now();

    switch (commandType) {
      case WSCommandType.connectResponse:
        // sends complete for connection.
        final connectCommand = ConnectCommand.fromBuffer(eventBuffer);
        final event = Event(EventType.connectionChanged,
            nodeId: connectCommand.nodeId, userId: connectCommand.userId);
        _nodeId = connectCommand.nodeId;
        _handleConnectedEvent(event);
        break;
      case WSCommandType.notificationList:
        final notificationBundle =
            Web3MQMessageListResponse.fromBuffer(eventBuffer);
        _notificationController.add(notificationBundle);
        break;
      case WSCommandType.message:
        final messageBundle = Web3MQRequestMessage.fromBuffer(eventBuffer);
        _messageController.add(messageBundle);
        break;
      case WSCommandType.messageSendingStatusUpdate:
        final messageStatusBundle =
            Web3MQMessageStatusResp.fromBuffer(eventBuffer);
        _messageUpdateController.add(messageStatusBundle);
        break;
      default:
        break;
    }
  }

  void _onConnectionError(error, [stacktrace]) {
    _logger?.warning('[WS] Error occurred', error, stacktrace);

    Web3MQWebSocketError wsError;
    if (error is WebSocketChannelException) {
      wsError = Web3MQWebSocketError.fromWebSocketChannelError(error);
    } else {
      wsError = Web3MQWebSocketError(error.toString());
    }

    final completer = connectionCompleter;
    // complete with error if not yet completed
    if (completer != null && !completer.isCompleted) {
      // complete the connection with error
      completer.completeError(wsError);
    }

    // resetting connect, reconnect request flag
    _resetRequestFlags();

    _reconnect();
  }

  void _onConnectionClosed() {
    _logger?.warning('[WS] Connection closed : $_nodeId');

    // resetting connect, reconnect request flag
    _resetRequestFlags();

    // resetting connection
    _nodeId = null;

    // check if we manually closed the connection
    if (_manuallyClosed) return;
    _reconnect();
  }

  void _handleConnectedEvent(Event event) {
    _nodeId = event.nodeId;
    _connectionStatus = ConnectionStatus.connected;
    _logger?.info('[WS] Connect success with ${event.toString()}');

    // notify user that connection is completed
    final completer = connectionCompleter;
    if (completer != null && !completer.isCompleted) {
      completer.complete(event);
    }

    _startMonitoringEvents();
  }

  void _resetRequestFlags({bool resetAttempts = false}) {
    _connectRequestInProgress = false;
    _reconnectRequestInProgress = false;
    if (resetAttempts) _reconnectAttempt = 0;
  }

  bool get _needsToReconnect {
    final lastEventAt = _lastEventAt;
    // means not yet connected or disconnected
    if (lastEventAt == null) return false;

    // means we missed a health check
    final now = DateTime.now();
    return now.difference(lastEventAt).inSeconds > reconnectionMonitorTimeout;
  }

  void _startReconnectionMonitor() {
    _logger?.info('Starting reconnection monitor');
    setPeriodicTimer(
      Duration(seconds: reconnectionMonitorInterval),
      (_) {
        final needsToReconnect = _needsToReconnect;
        _logger?.info('Needs to reconnect : $needsToReconnect');
        if (needsToReconnect) _reconnect();
      },
      immediate: true,
    );
  }

  void _startHealthCheck() {
    _logger?.info('[WS] Starting health check monitor');
    setPeriodicTimer(Duration(seconds: healthCheckInterval), (_) {
      final theNodeId = nodeId;
      if (theNodeId != null) {
        _logger?.info('[WS] Sending Ping');
        send(PingMessage.fromNodeId(theNodeId));
      }
    });
  }

  void _startMonitoringEvents() {
    _logger?.info('[WS] Starting monitoring events');

    // cancel all previous timers
    cancelAllTimers();

    _startHealthCheck();
    _startReconnectionMonitor();
  }

  void _stopMonitoringEvents() {
    _logger?.info('[WS] Stopped monitoring events');
    // reset lastEvent
    _lastEventAt = null;

    cancelAllTimers();
  }

  // returns the reconnect interval based on `reconnectAttempt` in milliseconds
  int _getReconnectInterval(int reconnectAttempt) {
    // try to reconnect in 0.25-25 seconds
    // (random to spread out the load from failures)
    final max = math.min(500 + reconnectAttempt * 2000, 25000);
    final min = math.min(
      math.max(250, (reconnectAttempt - 1) * 2000),
      25000,
    );
    return (math.Random().nextDouble() * (max - min) + min).floor();
  }

  /// builds uri
  Uri _buildUri() {
    final scheme = baseUrl.startsWith('https') ? 'wss' : 'ws';
    final host = baseUrl.replaceAll(RegExp(r'(^\w+:|^)\/\/'), '');
    return Uri(scheme: scheme, host: host, path: "messages");
  }
}
