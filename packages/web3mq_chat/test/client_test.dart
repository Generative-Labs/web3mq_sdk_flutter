import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:web3mq/src/client/client.dart';
import 'package:web3mq/src/error/error.dart';
import 'package:web3mq/src/models/did.dart';
import 'package:web3mq/src/models/user.dart';
import 'package:web3mq_websocket/web3mq_websocket.dart';

import 'fakes.dart';
import 'mocks.dart';

void main() {
  group('A group of Client tests', () {
    const apiKey = 'test-api-key';
    late final fakeService = FakeService();
    late Web3MQClient client;

    setUpAll(() {
      registerFallbackValue(FakeUser());
    });

    setUp(() async {
      final fakeWebsocket = FakeWebSocket();
      client = Web3MQClient(apiKey,
          ws: fakeWebsocket, apiService: fakeService, signer: MockSigner());
    });

    test('`.connectUser` should work fine', () async {
      final user =
          User('test-user-id', DID("type", "value"), "test-private-key");

      expectLater(
        // skipping first seed status -> ConnectionStatus.disconnected
        client.wsConnectionStatusStream.skip(1),
        emitsInOrder([
          ConnectionStatus.connecting,
          ConnectionStatus.connected,
        ]),
      );

      final res = await client.connectUser(user);
      expect(res, isNotNull);
      // expect(res, isSameUserAs(user));
    });

    tearDown(() {
      client.dispose();
    });
  });

  group('Fake web-socket connection functions failure', () {
    const appKey = 'test-api-key';
    late final service = FakeService();

    late Web3MQClient client;

    setUp(() {
      final ws = FakeWebSocketWithConnectionError();
      client = Web3MQClient(appKey,
          apiService: service, ws: ws, signer: MockSigner());
    });

    test('`.connectUser` should throw if `ws.connect` fails', () async {
      final user =
          User('test-user-id', DID("type", "value"), "test-private-key");
      try {
        await client.connectUser(user);
      } catch (e) {
        expect(e, isA<Web3MQWebSocketError>());
      }
    });
  });

  group('Register user', () {
    const apiKey = 'test-api-key';
    late final service = FakeService();

    late Web3MQClient client;

    late DID did;

    setUp(() {
      final ws = FakeWebSocket();
      did = DID("type", "value");
      client = Web3MQClient(apiKey,
          apiService: service, ws: ws, signer: MockSigner());
    });

    test('Register an user should be fail if did not setup WalletConnector',
        () async {
      try {
        final registerResult =
            await client.register(DID("type", "value"), "password");
        final user = await client.userWithDIDAndPrivateKey(
            did, registerResult.privateKey, Duration(days: 7));
        await client.connectUser(user);
      } catch (e) {
        expect(e, isA<Web3MQError>());
      }
    });

    test('Register an user', () async {
      client.walletConnector = MockWalletConnector();
      final registerResult = await client.register(did, "password");
      expect(registerResult.did, did);
      // expect(registerResult.privateKey, isNotNull);
    });
  });
}

Matcher isSameUserAs(User targetUser) => _IsSameUserAs(targetUser: targetUser);

class _IsSameUserAs extends Matcher {
  const _IsSameUserAs({required this.targetUser});

  final User targetUser;

  @override
  Description describe(Description description) =>
      description.add('is same user as $targetUser');

  @override
  bool matches(covariant User user, Map matchState) =>
      user.userId == targetUser.userId;
}
