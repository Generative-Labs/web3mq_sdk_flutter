import 'package:mocktail/mocktail.dart';
import 'package:web3mq_websocket/src/websocket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MockWebSocket extends Mock implements Web3MQWebSocketManager {}

class MockWebSocketChannel extends Mock implements WebSocketChannel {}

class MockWebSocketSink extends Mock implements WebSocketSink {}
