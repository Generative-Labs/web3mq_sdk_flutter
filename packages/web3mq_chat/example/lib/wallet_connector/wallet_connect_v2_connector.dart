// ignore_for_file: avoid_print

import 'package:url_launcher/url_launcher.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import 'package:web3mq/web3mq.dart';

/// You need to modify the code to match your Dapp metadata information and
/// the namespace required for the session request, as well as the parameters
/// required for the personal_sign function.
/// For more details on WalletConnectV2
/// plz see: https://github.com/WalletConnect/WalletConnectFlutterV2#commands-run-in-ci
class WalletConnectV2Connector implements WalletConnector {
  late Web3App wcClient;

  SessionData? session;

  @override
  Future<Wallet> connectWallet() async {
    // the projectId
    wcClient = await Web3App.createInstance(
      relayUrl: 'wss://relay.walletconnect.com',
      // The relay websocket URL, leave blank to use the default
      projectId: 'a0c738558362613d6a95c7b4bd9e8d6c',
      metadata: const PairingMetadata(
        name: 'web3mq-test dApp',
        description: 'A dapp that can request that transactions be signed',
        url: 'https://web3mq.com',
        icons: ['https://avatars.githubusercontent.com/u/40848675?s=200&v=4'],
      ),
    );

    ConnectResponse resp = await wcClient.connect(requiredNamespaces: {
      'eip155': const RequiredNamespace(
        chains: ["eip155:1"], // Ethereum chain
        methods: ['personal_sign'], events: [], // Requestable Methods
      )
    });

    final uri = resp.uri;
    if (null != uri) {
      await launchUrl(uri);
      session = await resp.session.future;
      final accounts = session!.namespaces['eip155']?.accounts;
      return Wallet(accounts ?? []);
    } else {
      return Wallet([]);
    }
  }

  @override
  Future<String> personalSign(String message, String address,
      {String? password}) async {
    final currentSession = session;
    if (currentSession == null) {
      throw Exception('Session is null');
    }

    final dynamic signResponse = await wcClient.request(
      topic: currentSession.topic,
      chainId: 'eip155:1',
      request: SessionRequestParams(
        method: 'personal_sign',
        params: [message, address],
      ),
    );

    // just send request won't lanuch wallet automatically,
    // so we need to launch it manually

    return signResponse as String;
  }
}
