import 'package:logging/logging.dart';
import 'package:web3mq_core/models.dart';
import 'package:web3mq_websocket/src/timer_helper.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

typedef WebSocketChannelProvider = WebSocketChannel Function(
  Uri uri, {
  Iterable<String>? protocols,
});

///
enum WebSocketConnectionStatus {
  /// websocket is connected.
  connected,

  /// websocket is connecting (usually reconnecting).
  connecting,

  /// websocket is disconnected and it's not reconnecting.
  disconnected,
}

///
abstract class WebSocketAbs {
  /// Connects to the `web3mq` server.
  Future<void> connect(User user);

  /// Disconnect from the `web3mq` server.
  void disconnect();

  /// This notifies of connection status changes
  Stream<WebSocketConnectionStatus> get connectionStatusStream;
}

///
class Web3MQWebSocket with TimerHelper implements WebSocketAbs {
  final String baseUrl;

  final Logger? _logger;

  final Signer _signer;

  Signer get signer => _signer;

  @visibleForTesting
  final WebSocketChannelProvider? webSocketChannelProvider;

  final EventHandler? handler;

  final int reconnectionMonitorInterval;

  final int healthCheckInterval;

  final int reconnectionMonitorTimeout;

  @override
  Stream<ConnectionStatus> get connectionStatusStream =>
      _connectionStatusController.stream.distinct();

  final _connectionStatusController =
      BehaviorSubject.seeded(ConnectionStatus.disconnected);

  set _connectionStatus(ConnectionStatus status) =>
      _connectionStatusController.add(status);

  ConnectionStatus get connectionStatus => _connectionStatusController.value;

  bool _connectRequestInProgress = false;

  ///
  WebSocketChannel? _channel;

  User? _user;

  DateTime? _lastEventAt;

  String? _nodeId;

  String? get nodeId => _nodeId;

  StreamSubscription? _webSocketChannelSubscription;

  bool _manuallyClosed = false;

  Completer<Event>? connectionCompleter;

  @override
  Future<Event> connect(User user) async {
    if (_connectRequestInProgress) {
      throw const Web3MQWebSocketError('''
        You've called connect twice,
        can only attempt 1 connection at the time,
        ''');
    }
    _connectRequestInProgress = true;
    _manuallyClosed = false;

    _user = user;
    _connectionStatus = ConnectionStatus.connecting;
    connectionCompleter = Completer<Event>();

    _signer.updateUser(user);

    try {
      await _initAndSubscribeToWebSocketChannel(_buildUri());
    } catch (e, stk) {
      _onConnectionError(e, stk);
    }

    return connectionCompleter!.future;
  }

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
    if (_reconnectRequestInProgress) return;
    _reconnectRequestInProgress = true;

    _stopMonitoringEvents();
    _closeWebSocketChannel();

    _reconnectAttempt += 1;
    _connectionStatus = ConnectionStatus.connecting;

    final delay = _getReconnectInterval(_reconnectAttempt);
    setTimer(
      Duration(milliseconds: delay),
      () async {
        final uri = _buildUri();
        try {
          _initAndSubscribeToWebSocketChannel(uri);
        } catch (e, stk) {
          _onConnectionError(e, stk);
        }
      },
    );
  }

  Future<void> _initAndSubscribeToWebSocketChannel(Uri uri) async {
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
      // sends connect command.
      send(await WebSocketMessageGenerator.connectMessage(_signer));
    } catch (error) {
      _logger?.warning('Connect Failed with ${error.toString()}');
      throw Web3MQWebSocketError.fromAnyMessage(error.toString());
    }
  }

  void send(Web3MQBufferConvertible message) {
    _channel?.send(message);
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
        handler?.call(event);
        break;
      case WSCommandType.notificationList:
        final notificationBundle =
            Web3MQMessageListResponse.fromBuffer(eventBuffer);
        final event = Event.fromNotification(notificationBundle);
        handler?.call(event);
        break;
      case WSCommandType.message:
        final messageBundle = Web3MQRequestMessage.fromBuffer(eventBuffer);
        // if message is sent to user,
        // and from others, change the topic to the sender's id.
        if (messageBundle.contentTopic.contains('user:') &&
            messageBundle.comeFrom != _user?.userId) {
          messageBundle.contentTopic = messageBundle.comeFrom;
        }
        final event = Event.fromChatMessage(messageBundle);
        handler?.call(event);
        break;
      case WSCommandType.messageSendingStatusUpdate:
        final messageStatusBundle =
            Web3MQMessageStatusResp.fromBuffer(eventBuffer);
        final event = Event.fromMessageUpdating(messageStatusBundle);
        handler?.call(event);
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
