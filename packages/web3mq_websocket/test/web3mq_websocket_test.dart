import 'dart:async';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:web3mq_websocket/src/error/error.dart';
import 'package:web3mq_websocket/src/models/buffer_convertible.dart';
import 'package:web3mq_websocket/src/models/pb/connect.pb.dart';
import 'package:web3mq_websocket/src/models/ws_models.dart';
import 'package:web3mq_websocket/src/utils/keypair.dart' as web3;
import 'package:web3mq_websocket/src/websocket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'mocks/mocks.dart';

void main() {
  group('A group of websocket tests', () {
    late WebSocketChannel webSocketChannel;
    late WebSocketSink webSocketSink;
    late Web3MQWebSocketManager webSocket;

    late WebSocketUser user;

    setUp(() async {
      webSocketChannel = MockWebSocketChannel();

      final keyPair = await Ed25519().newKeyPair();
      final privateKeyBytes = await keyPair.extractPrivateKeyBytes();
      final theKeyPair = web3.KeyPair(Uint8List.fromList(privateKeyBytes));
      user = WebSocketUser("test-user", theKeyPair.privateKeyHex);

      WebSocketChannel channelProvider(
        Uri uri, {
        Iterable<String>? protocols,
      }) =>
          webSocketChannel;

      webSocket = Web3MQWebSocketManager(
        appKey: 'api-key',
        baseUrl: "base-url",
        webSocketChannelProvider: channelProvider,
      );

      webSocketSink = MockWebSocketSink();
      when(() => webSocketChannel.sink).thenReturn(webSocketSink);

      var webSocketController = StreamController<List<int>>.broadcast();
      when(() => webSocketChannel.stream).thenAnswer(
        (_) => webSocketController.stream,
      );
      when(() => webSocketSink.add(any())).thenAnswer((invocation) {
        webSocketController.add(invocation.positionalArguments.first);
      });
      when(() => webSocketSink.addError(any())).thenAnswer((invocation) {
        webSocketController.addError(invocation.positionalArguments.first);
      });
      when(() => webSocketSink.close(any(), any())).thenAnswer(
        (_) async {
          webSocketController.close();
          // re-initializing for future events
          webSocketController = StreamController<List<int>>.broadcast();
        },
      );
    });

    test('`connect` successfully with the provided user', () async {
      const nodeId = 'test-node-id';

      final timer = Timer(const Duration(milliseconds: 300), () {
        webSocketSink.add(ConnectCommand(nodeId: nodeId).build());
      });

      expectLater(
        webSocket.connectionStatusStream,
        emitsInOrder([
          ConnectionStatus.disconnected,
          ConnectionStatus.connecting,
          ConnectionStatus.connected,
        ]),
      );

      final event = await webSocket.connect(user);
      expect(event.nodeId, nodeId);

      addTearDown(timer.cancel);
    });

    test('`switchUrl` successfully', () async {
      const nodeId = 'test-node-id';

      final timer = Timer(const Duration(milliseconds: 300), () {
        webSocketSink.add(ConnectCommand(nodeId: nodeId).build());
      });

      expectLater(
        webSocket.connectionStatusStream,
        emitsInOrder([
          ConnectionStatus.disconnected,
          ConnectionStatus.connecting,
          ConnectionStatus.connected,
        ]),
      );

      final event = await webSocket.connect(user);
      expect(event.nodeId, nodeId);

      addTearDown(timer.cancel);

      final timer1 = Timer(const Duration(milliseconds: 500), () {
        webSocketSink.add(ConnectCommand(nodeId: nodeId).build());
      });

      expectLater(
        webSocket.connectionStatusStream,
        emitsInOrder([
          ConnectionStatus.connected,
          ConnectionStatus.disconnected,
          ConnectionStatus.connecting,
          ConnectionStatus.connected,
        ]),
      );

      webSocket.switchUrl('a-new-url');
      addTearDown(timer1.cancel);
    });

    test('`connect`, `disconnect` and `connect` again without waiting',
        () async {
      const nodeId = 'test-node-id';

      // Sends connect event to web-socket stream
      final timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
        webSocketSink.add(ConnectCommand(nodeId: nodeId).build());
      });

      await webSocket.connect(user);

      webSocket
        ..disconnect()
        ..connect(user)
        ..disconnect();

      final event = await webSocket.connect(user);
      expect(event.nodeId, isNotEmpty);
      addTearDown(timer.cancel);
    });

    test(
      'should `reconnect` automatically '
      'if `onMessage` throws error after getting connected',
      () async {
        const nodeId = 'test-node-id';
        // Sends connect event to web-socket stream
        final timer = Timer(const Duration(milliseconds: 300), () {
          webSocketSink.add(ConnectCommand(nodeId: nodeId).build());
        });

        expectLater(
          webSocket.connectionStatusStream,
          emitsInOrder([
            ConnectionStatus.disconnected,
            ConnectionStatus.connecting,
            ConnectionStatus.connected,
            // starts reconnecting
            ConnectionStatus.connecting,
            ConnectionStatus.connected,
          ]),
        );

        await webSocket.connect(user);

        final error = Web3MQWebSocketError("Invalid request");
        webSocketSink.addError(error);

        final reconnectTimer = Timer(const Duration(seconds: 3), () {
          webSocketSink.add(ConnectCommand(nodeId: nodeId).build());
        });

        expect(webSocket.nodeId, nodeId);

        addTearDown(() {
          timer.cancel();
          reconnectTimer.cancel();
        });
      },
    );

    tearDown(() {
      webSocket.disconnect();
    });
  });
}

extension Build on ConnectCommand {
  List<int> build() {
    List<int> bytes = <int>[0];
    bytes.add(WSCommandType.connectResponse.code);
    bytes.addAll(writeToBuffer().toList());
    return bytes;
  }
}
