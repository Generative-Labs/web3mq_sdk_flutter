import 'package:flutter/material.dart';
import 'package:web3mq/web3mq.dart';
import 'package:web3mq_sdk_flutter_demo/home_page.dart';

import 'cache.dart';
import 'connect_wallet_page.dart';
import 'demo_app_wallet_connector.dart';

// group:ab0710a42f94b4613d02cb5bd165aa69843d9ed5”
// testnet: https://testnet-ap-singapore-1.web3mq.com
// dev: 'https://dev-us-west-2.web3mq.com'

/// A `Web3MQ` shared client.
/// eKsEePNSVXTaBLRy
final client = Web3MQClient("eKsEePNSVXTaBLRy", baseURL: DevEndpoint.sg1);

///
final dappConnectClient = DappConnectClient('eKsEePNSVXTaBLRy',
    AppMetadata('Dapp', 'for dart dapp test', 'url', const [''], null));

User? _currentUser;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  client.persistenceClient = Web3MQPersistenceClient();
  client.walletConnector = DemoAppWalletConnector();
  _currentUser = await CacheHelper.loadUser();
  dappConnectClient.connectUser();
  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.client});

  /// Instance of [Client] we created earlier.
  final Web3MQClient client;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Web3MQ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _currentUser != null
          ? HomePage(user: _currentUser!)
          : const ConnectWalletPage(title: 'Web3MQ SDK Demo App'),
    );
  }
}