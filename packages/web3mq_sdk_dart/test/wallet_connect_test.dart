import 'package:test/test.dart';

import 'mocks.dart';

void main() {
  test('connect wallet should work', () async {
    final walletConnector = MockWalletConnector();
    final wallet = await walletConnector.connectWallet();
    expect(wallet, isNotNull);
  });

  test('personal sign should work', () async {
    final walletConnector = MockWalletConnector();
    final signature = await walletConnector.personalSign("hello", "0x1123");
    expect(signature, isNotNull);
  });

  test("handle connector error", () async {
    final connector = MockFailedWalletConnector();
    try {
      final _ = await connector.connectWallet();
    } catch (e) {
      expect(e, isNotNull);
    }
  });
}
