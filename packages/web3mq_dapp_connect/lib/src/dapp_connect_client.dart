import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web3mq_dapp_connect/src/utils/keypair.dart';
import 'package:web3mq_websocket/web3mq_websocket.dart';

import 'error/error.dart';
import 'model/export.dart';
import 'serializer.dart';
import 'storage/record.dart';
import 'storage/storage.dart';
import 'utils/endpoint.dart';
import 'utils/id_generator.dart';
import 'utils/logger.dart';

///
abstract class DappConnectClientProtocol {
  ///
  Future<List<Session>> get sessions;

  ///
  Stream<ConnectionStatus> get connectionStatusStream;

  ///
  Stream<SessionProposal> get sessionProposalStream;

  ///
  Stream<Request> get requestStream;

  ///
  Stream<Response> get responseStream;

  ///
  Future<void> deleteSession(String topic);

  ///
  Future<DappConnectURI> createSessionProposalURI(
      Map<String, ProposalNamespace> requiredNamespaces);

  ///
  void pairURI(DappConnectURI uri);

  ///
  Future<void> approveSessionProposal(String proposalId,
      Map<String, SessionNamespace> sessionNamespace, Duration expires);

  ///
  Future<void> rejectSessionProposal(String proposalId);

  ///
  Future<void> sendSuccessResponse(Request request, dynamic result);

  ///
  Future<void> sendErrorResponse(Request request, int code, String message);

  ///
  Future<Response> sendRequest(
      String topic, String method, Map<String, dynamic> params);

  ///
  Future<void> cleanup();

  ///
  Future<void> connectUser({DappConnectUser user});

  ///
  void closeConnection();
}

///
class DappConnectClient extends DappConnectClientProtocol {
  ///
  final Level logLevel;

  late final Logger logger = detachedLogger('📡');

  final LogHandlerFunction logHandlerFunction;

  /// Default logger for the [DappConnectClient].
  Logger detachedLogger(String name) => Logger.detached(name)
    ..level = logLevel
    ..onRecord.listen(logHandlerFunction);

  ///
  DappConnectClient(String apiKey, AppMetadata metadata,
      {this.logLevel = Level.ALL,
      this.logHandlerFunction = Web3MQLogger.defaultLogHandler,
      String? baseURL,
      UserIdGenerator? userIdGenerator,
      RequestIdGenerator? idGenerator,
      Storage? storage,
      KeyStorage? keyStorage,
      ShareKeyCoder? shareKeyCoder,
      Serializer? serializer,
      Web3MQWebSocketManager? ws})
      : _apiKey = apiKey,
        _appMetadata = metadata {
    _ws = ws ??
        Web3MQWebSocketManager(
          baseUrl: baseURL ?? TestnetEndpoint.sg1,
          logger: detachedLogger('🔌'),
        );

    _userIdGenerator = userIdGenerator ?? DappConnectUserIdGenerator();

    _idGenerator = idGenerator ?? DappConnectRequestIdGenerator();

    _storage = storage ?? Web3MQStorage();

    _shareKeyCoder = shareKeyCoder ?? DappConnectShareKeyCoder();

    _keyStorage = keyStorage ?? DappConnectKeyStorage();

    _serializer = serializer ?? Serializer(_keyStorage, _shareKeyCoder);
  }

  @override
  Future<List<Session>> get sessions => _storage.getAllSessions();

  @override
  Stream<Request> get requestStream => _newRequestController.stream;

  @override
  Stream<Response> get responseStream => _newResponseController.stream;

  @override
  Stream<SessionProposal> get sessionProposalStream =>
      _sessionProposalController.stream;

  /// Stream of new messages.
  Stream<DappConnectMessage> get newMessageStream =>
      _newMessageController.stream;

  final _newRequestController = BehaviorSubject<Request>();

  final _newMessageController = BehaviorSubject<DappConnectMessage>();

  final _sessionProposalController = BehaviorSubject<SessionProposal>();

  final _newResponseController = BehaviorSubject<Response>();

  Duration requestTimeoutInterval = const Duration(minutes: 3);

  void handleEvent(Event event) {
    switch (event.type) {
      case EventType.notificationMessageNew:
        break;
      case EventType.connectionChanged:
        break;
      case EventType.messageNew:
        print('debug:messageNew: ${event.message}');
        final wsMessage = event.message;
        if (null == wsMessage) return;
        if (wsMessage.messageType != MessageType.bridge) {
          break;
        }
        final thePayload = utf8.decode(wsMessage.payload);
        if (thePayload.isNotEmpty) {
          final json = jsonDecode(thePayload);
          final payload = MesasgePayload.fromJson(json);
          final dappMessage = DappConnectMessage(payload, wsMessage.userId);
          _newMessageController.add(dappMessage);
          _onReceiveMessage(dappMessage);
        }
        break;
      default:
        break;
    }
  }

  final AppMetadata _appMetadata;

  final String _apiKey;

  late final RequestIdGenerator _idGenerator;

  late final UserIdGenerator _userIdGenerator;

  /// By default the Chat client will write all messages with level Warn or
  /// Error to stdout.
  late final Web3MQWebSocketManager _ws;

  late final KeyStorage _keyStorage;

  late final ShareKeyCoder _shareKeyCoder;

  late final Serializer _serializer;

  late final Storage _storage;

  String get endpoint => _ws.baseUrl;

  Future<Session> connectWallet(
      Map<String, ProposalNamespace> requiredNamespaces) async {
    final theUser = currentUser;
    if (null == theUser) {
      throw DappConnectError.currentUserNotFound();
    }
    final privateKey = theUser.sessionKey;
    final keyPair = KeyPair.fromPrivateKeyHex(privateKey);
    final publicKey = await keyPair.publicKeyHex;
    final uri = await createSessionProposalURI(requiredNamespaces);
    final deepLink = uri.deepLinkURL;
    await _openURLIfCould(deepLink);
    final rawResposne = await _waitingForResponse(uri.request.id);
    final result = rawResposne.result;
    if (null != result) {
      try {
        // convert List<int> to SessionProposalResult
        final sessionProposalResult =
            SessionProposalResult.fromBytes(result.cast<int>());
        final session = Session(
            rawResposne.topic,
            uri.topic,
            Participant(publicKey, _appMetadata),
            Participant(rawResposne.publicKey, sessionProposalResult.metadata),
            sessionProposalResult.sessionProperties.expiry,
            sessionProposalResult.sessionNamespaces);
        _storage.setSession(session);
        return session;
      } catch (e) {
        rethrow;
      }
    } else {
      throw rawResposne.error ?? DappConnectError.unknown();
    }
  }

  Future<void> _openURLIfCould(Uri uri) async {
    // open url if could
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Future<void> approveSessionProposal(String proposalId,
      Map<String, SessionNamespace> sessionNamespace, Duration expires) async {
    final proposal = await _storage.getSessionProposal(proposalId);
    if (proposal == null) {
      throw DappConnectError.proposalNotFound();
    }
    final theUser = currentUser;
    if (null == theUser) {
      throw DappConnectError.currentUserNotFound();
    }

    final privateKeyHex = await _keyStorage.privateKeyHex;
    final keyPair = KeyPair.fromPrivateKeyHex(privateKeyHex);
    final publicKeyHex = await keyPair.publicKeyHex;

    // 1. send response
    // 2. remove proposal
    // 3. set session
    // 4. redirect to dapps
    final sessionProperties = SessionProperties.fromExpiryDuration(expires);

    final result = SessionProposalResult(
        sessionNamespace, sessionProperties, _appMetadata);

    final response = RPCResponse(
        proposalId, RequestMethod.providerAuthorization,
        result: result);

    _sendPayloadContentBytes(response.toBytes(), proposal.pairingTopic,
        proposal.proposer.publicKey, privateKeyHex);

    _storage.removeSessionProposal(proposalId);

    final session = Session(
        proposal.pairingTopic,
        theUser.userId,
        Participant(publicKeyHex, _appMetadata),
        proposal.proposer,
        sessionProperties.expiry,
        sessionNamespace);
    _storage.setSession(session);

    await _backToDapp(proposal.proposer.appMetadata.redirect);
  }

  @override
  Future<void> rejectSessionProposal(String proposalId) async {
    final proposal = await _storage.getSessionProposal(proposalId);
    if (proposal == null) {
      throw DappConnectError.proposalNotFound();
    }

    final theUser = currentUser;
    if (null == theUser) {
      throw DappConnectError.currentUserNotFound();
    }

    final response = RPCResponse(
        proposalId, RequestMethod.providerAuthorization,
        error: RPCError(
            code: 5000, message: 'User disapproved requested methods'));

    _sendPayloadContentBytes(response.toBytes(), proposal.pairingTopic,
        proposal.proposer.publicKey, theUser.sessionKey);

    await _backToDapp(proposal.proposer.appMetadata.redirect);
  }

  @override
  Future<DappConnectURI> createSessionProposalURI(
      Map<String, ProposalNamespace> requiredNamespaces) async {
    final theUser = currentUser;
    if (null == theUser) {
      throw DappConnectError.currentUserNotFound();
    }
    final privateKey = theUser.sessionKey;
    final keyPair = KeyPair.fromPrivateKeyHex(privateKey);
    final publicKey = await keyPair.publicKeyHex;
    final proposer = Participant(publicKey, _appMetadata);

    final proposalId = _idGenerator.next();
    final proposal = SessionProposalContent(
        requiredNamespaces, SessionProperties.fromDefault());
    final request = SessionProposalRPCRequest(
        proposalId, RequestMethod.providerAuthorization, proposal);
    return DappConnectURI(theUser.userId, proposer, request);
  }

  @override
  void pairURI(DappConnectURI uri) {
    final request = uri.request;
    final proposal = request.params;
    final sessionProposal = SessionProposal(
        request.id,
        uri.topic,
        uri.proposer,
        proposal?.requiredNamespaces ?? {},
        proposal?.sessionProperties ?? SessionProperties.fromDefault());
    _storage.setSessionProposal(sessionProposal);
    _sessionProposalController.add(sessionProposal);
  }

  @override
  Future<void> deleteSession(String topic) async {
    _storage.removeSession(topic);
    _storage.removeRecord(topic);
  }

  @override
  Future<Response> sendRequest(
      String topic, String method, Map<String, dynamic> params) async {
    final requestId = _idGenerator.next();
    final rpcRequest = RPCRequest.from(requestId, method, params);
    await _sendRequest(rpcRequest, topic);
    await _jumpToWalletIfNeeded();
    return await _waitingForResponse(requestId);
  }

  @override
  Future<void> sendErrorResponse(
      Request request, int code, String message) async {
    final response = RPCResponse(
        request.id, RequestMethod.providerAuthorization,
        error: RPCError(code: code, message: message));
    await _sendResponse(response, request);
    _backToDapp(request.sender?.appMetadata.redirect);
  }

  @override
  Future<void> sendSuccessResponse(Request request, dynamic result) async {
    final response = RPCResponse(
        request.id, RequestMethod.providerAuthorization,
        result: result);
    await _sendResponse(response, request);
    _backToDapp(request.sender?.appMetadata.redirect);
  }

  Future<String> personalSign(String message, String address, String topic,
      {String? password}) async {
    final session = await _storage.getSession(topic);
    if (null == session) {
      throw DappConnectError.sessionNotFound();
    }
    final theUser = currentUser;
    if (null == theUser) {
      throw DappConnectError.currentUserNotFound();
    }
    final requestId = _idGenerator.next();
    final params = List<String>.from([message, address]);
    final request = RPCRequest(requestId, RequestMethod.personalSign, params);
    await _sendPayloadContentBytes(request.toBytes(), topic,
        session.peerParticipant.publicKey, theUser.sessionKey);
    await _jumpToWalletIfNeeded();
    final response = await _waitingForResponse(requestId);
    final result = response.result;
    if (null != result) {
      return utf8.decode(result);
    } else {
      throw response.error ?? DappConnectError.unknown();
    }
  }

  Future<void> _jumpToWalletIfNeeded() async {
    if (kIsWeb) {
      return;
    }
    final uri = Uri.parse('web3mq://');
    try {
      await _openURLIfCould(uri);
    } catch (e) {
      logger.warning('openURLIfCould Error: $e');
    }
  }

  Future<void> _backToDapp(String? url) async {
    // direct
    if (null == url) {
      // back to redirect
      if (!kIsWeb) {
        // TODO: back to previeous app
      }
    } else {
      final uri = Uri.parse(url);
      await _openURLIfCould(uri);
    }
  }

  @override
  Future<void> cleanup() async {
    _storage.clear();
    _keyStorage.reset();
  }

  @override
  Future<void> connectUser({DappConnectUser? user}) async {
    final paramUser = user;
    if (null != paramUser) {
      await _connectUser(paramUser);
      return;
    }
    final privateKey = await _keyStorage.privateKeyHex;
    final keyPair = KeyPair.fromPrivateKeyHex(privateKey);
    final publicKeyBase64String = await keyPair.publicKeyBase64;
    final userId =
        await _userIdGenerator.create(_apiKey, publicKeyBase64String);
    final newUser = DappConnectUser(userId, keyPair.privateKeyHex);
    await _connectUser(newUser);
  }

  /// Connects the user to the websocket.
  Future<void> _connectUser(DappConnectUser user) async {
    if (_ws.connectionCompleter?.isCompleted == false) {
      throw const Web3MQError(
        'User already getting connected, try calling `disconnectUser` '
        'before trying to connect again',
      );
    }

    logger.info('setting user : ${user.userId}');

    try {
      currentUser = user;
      await openConnection();
    } catch (e, stk) {
      logger.severe('error connecting user : ${user.userId}', e, stk);
      rethrow;
    }
  }

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
  @override
  Stream<ConnectionStatus> get connectionStatusStream =>
      _wsConnectionStatusController.stream.distinct();

  ///
  DappConnectUser? currentUser;

  /// Creates a new WebSocket connection with the current user.
  Future<DappConnectUser> openConnection() async {
    assert(currentUser != null, 'User is not set on client');

    final user = currentUser!;

    logger.info('Opening web-socket connection for ${user.userId}');

    if (wsConnectionStatus == ConnectionStatus.connecting) {
      throw Web3MQError('Connection already in progress for ${user.userId}');
    }

    if (wsConnectionStatus == ConnectionStatus.connected) {
      throw Web3MQError('Connection already available for ${user.userId}');
    }

    _wsConnectionStatus = ConnectionStatus.connecting;

    // skipping `ws` seed connection status -> ConnectionStatus.disconnected
    // otherwise [connectionStatusStream] will emit in order
    // 1. ConnectionStatus.disconnected -> client seed status
    // 2. ConnectionStatus.connecting -> client connecting status
    // 3. ConnectionStatus.disconnected -> ws seed status
    _connectionStatusSubscription =
        _ws.connectionStatusStream.skip(1).listen(_connectionStatusHandler);

    try {
      await _ws.connect(WebSocketUser(user.userId, user.sessionKey),
          mode: ConnectMode.bridge);
      return user;
    } catch (e, stk) {
      logger.severe('error connecting ws', e, stk);
      rethrow;
    }
  }

  void _connectionStatusHandler(ConnectionStatus status) async {
    _wsConnectionStatus = status;
    final event = Event(EventType.connectionChanged,
        nodeId: _ws.nodeId, connectionStatus: status);
    handleEvent(event);
  }

  @override
  void closeConnection() {
    if (wsConnectionStatus == ConnectionStatus.disconnected) return;

    logger.info('Closing web-socket connection for ${currentUser?.userId}');
    _wsConnectionStatus = ConnectionStatus.disconnected;

    _connectionStatusSubscription?.cancel();
    _connectionStatusSubscription = null;

    _ws.disconnect();
  }

  Map<String, dynamic> _bytesToMap(List<int> bytes) {
    final jsonString = utf8.decode(bytes);
    return jsonDecode(jsonString);
  }

  void _onReceiveRequest(Request request) {
    print('debug:_onReceiveRequest: ${request.params}');
    _newRequestController.add(request);
    _storage.setRecord(Record.fromRequest(request));
  }

  void _onReceiveResponse(Response response) {
    print('debug:_onReceiveResponse: ${response.result}');
    _newResponseController.add(response);
    _storage.getRecord(response.topic).then((value) {
      if (null != value) {
        final fianlRecord = value.copyWith(response: response);
        _storage.setRecord(fianlRecord);
      }
    });
  }

  Future<void> _sendResponse(RPCResponse response, Request request) async {
    final privateKey = await _keyStorage.privateKeyHex;
    final session = await _storage.getSession(request.topic);
    if (null == session) {
      throw DappConnectError.sessionNotFound();
    }
    await _sendPayloadContentBytes(response.toBytes(), session.topic,
        session.peerParticipant.publicKey, privateKey);
  }

  Future<void> _sendRequest(RPCRequest request, String topic) async {
    final privateKey = await _keyStorage.privateKeyHex;
    final session = await _storage.getSession(topic);
    if (null == session) {
      throw DappConnectError.sessionNotFound();
    }
    await _sendPayloadContentBytes(request.toBytes(), session.topic,
        session.peerParticipant.publicKey, privateKey);
  }

  /// Sends a message to the peer participant.
  Future<void> _sendPayloadContentBytes(List<int> bytes, String topic,
      String peerPublicKeyHex, String privateKeyHex) async {
    final theUser = currentUser;
    if (null == theUser) {
      throw DappConnectError.currentUserNotFound();
    }

    final encrypted =
        await _serializer.encrypt(bytes, peerPublicKeyHex, privateKeyHex);

    final keyPair = KeyPair.fromPrivateKeyHex(privateKeyHex);
    final publicKeyHex = await keyPair.publicKeyHex;
    final payload = MesasgePayload(encrypted, publicKeyHex);

    // final message = DappConnectMessage(payload, theUser.userId);
    // Check the connection status. If currently connected, send the message.
    // If not connected, wait for a connection and continue sending the message.
    if (wsConnectionStatus != ConnectionStatus.connected) {
      await _waitingForConnected();
    }

    await _sendDappConnectMessageByPayload(
        payload, topic, theUser.userId, privateKeyHex);
  }

  void _onReceiveMessage(DappConnectMessage message) async {
    print('debug:onReceiveMessage: ${message.payload}');
    final privateKey = await _keyStorage.privateKeyHex;
    final bytes = await _serializer.decrypt(
        message.payload.content, message.payload.publicKey, privateKey);
    final json = _bytesToMap(bytes);

    try {
      final rpcResponse = RPCResponse.fromJson(json);
      if (rpcResponse.isInvalid) {
        throw Error();
      }
      final session = await _storage.getSession(message.fromTopic);
      final response = Response.fromRpcResponse(
        rpcResponse,
        message.fromTopic,
        message.payload.publicKey,
        session?.peerParticipant,
      );
      _onReceiveResponse(response);
      return;
    } catch (e) {
      logger.warning('Error: $e');
      logger.warning('Unknown message type: $json');
    }

    try {
      final rpcRequest = RPCRequest.fromJson(json);
      final session = await _storage.getSession(message.fromTopic);
      final request = Request.fromRpcRequest(rpcRequest, message.fromTopic,
          message.payload.publicKey, session?.peerParticipant);
      _onReceiveRequest(request);
      return;
    } catch (e) {
      logger.warning('Error: $e');
      logger.warning('Unknown message type: $json');
    }
  }

  Future<void> _waitingForConnected() async {
    final completer = Completer<void>();
    StreamSubscription<ConnectionStatus>? subscription;
    subscription = connectionStatusStream
        .where((status) => status == ConnectionStatus.connected)
        .take(1)
        .listen((status) {
      subscription?.cancel();
      completer.complete();
    }, onError: (error) {
      subscription?.cancel();
      completer.completeError(error);
    }, cancelOnError: true);
    await completer.future;
  }

  Future<Response> _waitingForResponse(String requestId) async {
    final completer = Completer<Response>();
    StreamSubscription<Response>? subscription;
    subscription = responseStream
        .timeout(requestTimeoutInterval, onTimeout: (sink) {
          sink.addError(DappConnectError.timeout);
        })
        .where((response) => response.id == requestId)
        .take(1)
        .listen((response) {
          subscription?.cancel();
          completer.complete(response);
        }, onError: (error) {
          subscription?.cancel();
          completer.completeError(error);
        }, cancelOnError: true);
    return completer.future;
  }

  Future<void> _sendDappConnectMessageByPayload(MesasgePayload payload,
      String topic, String userId, String privateKeyHex) async {
    final wsMessage =
        await _convertToChatMessage(payload, topic, userId, privateKeyHex);
    _ws.send(wsMessage);
  }

  Future<ChatMessage> _convertToChatMessage(MesasgePayload payload,
      String topic, String userId, String privateKeyHex) async {
    final messageJson = jsonEncode(payload.toJson());
    final messageBytes = utf8.encode(messageJson);
    final keyPair = KeyPair.fromPrivateKeyHex(privateKeyHex);
    return await MessageFactory.fromBytes(
        messageBytes, topic, userId, keyPair.privateKey, _ws.nodeId,
        messageType: MessageType.bridge, cipherSuite: CipherSuit.x25519);
  }
}
