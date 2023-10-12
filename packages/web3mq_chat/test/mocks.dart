import 'package:dio/dio.dart';
import 'package:fixnum/fixnum.dart';
import 'package:logging/logging.dart';
import 'package:mocktail/mocktail.dart';
import 'package:web3mq/src/api/notification_api.dart';
import 'package:web3mq/src/api/user_api.dart';
import 'package:web3mq/src/client/client.dart';
import 'package:web3mq/src/http/http_client.dart';
import 'package:web3mq/src/models/models.dart';
import 'package:web3mq/src/utils/signer.dart';
import 'package:web3mq_websocket/web3mq_websocket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MockDio extends Mock implements Dio {
  BaseOptions? _options;

  @override
  BaseOptions get options => _options ??= BaseOptions();

  Interceptors? _interceptors;

  @override
  Interceptors get interceptors => _interceptors ??= Interceptors();
}

class MockLogger extends Mock implements Logger {
  @override
  Level get level => Level.ALL;
}

class MockHttpClient extends Mock implements Web3MQHttpClient {}

class MockNotificationApi extends Mock implements NotificationApi {}

class MockUserApi extends Mock implements UserApi {}

class MockClient extends Mock implements Web3MQClient {}

class MockWebSocket extends Mock implements Web3MQWebSocketManager {}

class MockWebSocketChannel extends Mock implements WebSocketChannel {}

class MockWebSocketSink extends Mock implements WebSocketSink {}

class MockSigner extends Mock implements Signer {
  @override
  Future<String> sign(String raw) {
    return Future(() => "test-signature");
  }

  @override
  Future<ConnectRequestSignature> signatureForConnectRequest() {
    return Future(() => ConnectRequestSignature(
        "test-nodeId", "test-userId", Int64(0), "test-signature"));
  }

  @override
  Future<SignResult> signatureForRequest(String? content) {
    return Future(
        () => SignResult("signature", DateTime.now(), "test-user-id"));
  }

  @override
  Future<void> updateUser(User? user) async {}
}

class MockWallet extends Mock implements Wallet {
  @override
  List<String> get accounts => ["eip155:0x"];
}

class MockWalletConnector extends Mock implements WalletConnector {
  @override
  Future<String> personalSign(String message, String address,
      {String? password}) {
    return Future.value("test_signature");
  }

  @override
  Future<Wallet> connectWallet() {
    return Future.value(MockWallet());
  }
}

class MockFailedWalletConnector extends Mock implements WalletConnector {
  @override
  Future<String> personalSign(String message, String address,
      {String? password}) {
    throw UnimplementedError();
  }

  @override
  Future<Wallet> connectWallet() {
    throw UnimplementedError();
  }
}
