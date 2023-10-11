import 'package:web3mq/web3mq.dart';
import 'package:web3mq_dapp_connect/web3mq_dapp_connect.dart';
import 'package:web3mq_sdk_flutter_demo/main.dart';

class DemoAppWalletConnector extends WalletConnector {
  // connect the client when initailized.
  DemoAppWalletConnector() {
    dappConnectClient.connectUser();
  }

  @override
  Future<Wallet> connectWallet() async {
    final session = await dappConnectClient.connectWallet({
      'eip255': ProposalNamespace(
          chains: const {"eip155:1", "eip155:10"},
          methods: const {'personal_sign'},
          events: const {"chainChanged", "accountsChanged"})
    });
    final accounts = session.namespaces.values.first.accounts;
    final wallet = Wallet(accounts.toList());
    return wallet;
  }

  @override
  Future<String> personalSign(String message, String address,
      {String? password}) async {
    final sessions = await dappConnectClient.sessions;
    final session = sessions.first;
    return await dappConnectClient.personalSign(
        message, address, session.topic);
  }
}
