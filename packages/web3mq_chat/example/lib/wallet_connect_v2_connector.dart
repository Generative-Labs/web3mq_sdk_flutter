import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import 'package:web3mq/web3mq.dart';

class WalletConnectV2Connector implements WalletConnector {
  late Web3App wcClient;

  SessionData? session;

  @override
  Future<Wallet> connectWallet() async {
    wcClient = await Web3App.createInstance(
      relayUrl:
          'wss://relay.walletconnect.com', // The relay websocket URL, leave blank to use the default
      projectId: '123',
      metadata: const PairingMetadata(
        name: 'dApp (Requester)',
        description: 'A dapp that can request that transactions be signed',
        url: 'https://walletconnect.com',
        icons: ['https://avatars.githubusercontent.com/u/37784886'],
      ),
    );

    ConnectResponse resp = await wcClient.connect(requiredNamespaces: {
      'eip155': const RequiredNamespace(
        chains: ['eip155:1'], // Ethereum chain
        methods: ['eth_signTransaction'], // Requestable Methods
        events: ['eth_sendTransaction'], // Requestable Events
      ),
      'kadena': const RequiredNamespace(
        chains: ['kadena:mainnet01'], // Kadena chain
        methods: ['kadena_quicksign_v1'], // Requestable Methods
        events: ['kadena_transaction_updated'], // Requestable Events
      ),
    });

    session = await resp.session.future;
    final accounts = session!.namespaces['eip155:1']?.accounts;
    return Wallet(accounts ?? []);
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
      request: const SessionRequestParams(
        method: 'personal_sign',
        params: 'json serializable parameters',
      ),
    );
    return signResponse as String;
  }
}
