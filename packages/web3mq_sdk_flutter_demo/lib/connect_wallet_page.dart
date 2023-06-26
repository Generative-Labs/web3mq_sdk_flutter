import 'package:flutter/material.dart';
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
