import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web3mq/web3mq.dart';
import 'package:web3mq_sdk_flutter_demo/create_password_page.dart';
import 'package:web3mq_sdk_flutter_demo/enter_password_page.dart';

import 'main.dart';

class ConnectWalletPage extends StatefulWidget {
  const ConnectWalletPage({super.key, required this.title});

  final String title;

  @override
  State<ConnectWalletPage> createState() => _ConnectWalletPageState();
}

class _ConnectWalletPageState extends State<ConnectWalletPage> {
  String? address;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          // add a item to test the url lanuch
          IconButton(
            onPressed: () {
              testUriLanuch();
            },
            icon: const Icon(Icons.launch),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(address ?? "address"),
            TextButton(
              onPressed: _connectWallet,
              child: const Text("Connect wallet"),
            ),
          ],
        ),
      ),
    );
  }

  void testUriLanuch() {
    const url =
        'topic=%22bridge%3A6b0dd80c68422333aeed075c69b97e8a42efd8b6%22&proposer=%7B%22publicKey%22%3A%22ced0843d82baef4a11d8da36edf6a93eea4aae2b7bb1baa88cfb6b83e6b600df%22%2C%22appMetadata%22%3A%7B%22name%22%3A%22Dapp%22%2C%22description%22%3A%22for+dart+dapp+test%22%2C%22url%22%3A%22url%22%2C%22icons%22%3A%5B%22%22%5D%2C%22redirect%22%3Anull%7D%7D&request=%7B%22id%22%3A%225151686130597461000%22%2C%22method%22%3A%22provider_authorization%22%2C%22params%22%3A%7B%22requiredNamespaces%22%3A%7B%7D%2C%22sessionProperties%22%3A%7B%22expiry%22%3A%222023-06-14T18%3A36%3A37.461192%22%7D%7D%7D';
    final uri = Uri.parse('web3mq://?$url');
    canLaunchUrl(uri).then((value) {
      print('debug:canLaunchUrl:$value');
    });
  }

  // connects wallet
  void _connectWallet() async {
    // _showAccountModal();
    final wallet = await client.walletConnector?.connectWallet();
    final accountString = wallet?.accounts.first;
    if (null == accountString) return;
    final account = Account.from(accountString);

    final theAddress = account.address;
    setState(() {
      address = theAddress;
    });
    final did = DID("eth", theAddress);
    try {
      final userInfo = await client.userInfo(did.type, did.value);
      if (null != userInfo) {
        _pushToLoginPage(userInfo);
        return;
      }
    } catch (e) {
      // should go to create an user.
    }
    _pushToRegisterPage(did);
  }

  void _pushToLoginPage(UserInfo userInfo) {
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              LoginPage(title: "Enter password", userInfo: userInfo)),
    );
  }

  void _pushToRegisterPage(DID did) {
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CreateUserPage(
                title: "Create password",
                did: did,
              )),
    );
  }
}
