import 'package:web3mq_websocket/web3mq_websocket.dart';

void main() async {
  final websocket = Web3MQWebSocketManager(
      baseUrl: 'endpoint', reconnectionMonitorInterval: 20);

  // lisnten the new message stream.
  websocket.messageStream.listen((event) {});

  // lisnten the new notification stream.
  websocket.notificationStream.listen((event) {});

  // lisnten the connection status stream.
  websocket.connectionStatusStream.listen((event) {});

  /// listen the sending status stream.
  websocket.messageUpdateStream.listen((event) {});

  // replace with your own user
  await websocket.connect(WebSocketUser('userId', 'sessionKey'));
  websocket.sendText('text', 'topic');

  websocket.sendText('text', 'topic',
      threadId: '', cipherSuite: '', needStore: false, extraData: {});
}
