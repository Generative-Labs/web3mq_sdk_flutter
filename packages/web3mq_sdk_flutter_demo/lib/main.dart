import 'package:flutter/material.dart';
import 'package:web3mq/web3mq.dart';
import 'package:web3mq_dapp_connect/web3mq_dapp_connect.dart';
import 'package:web3mq_sdk_flutter_demo/inner_wallet_connector.dart';

import 'cache.dart';
import 'connect_wallet_page.dart';
import 'home_page.dart';

/// Note: replace the `apiKey` with your own.
const apiKey = 'eKsEePNSVXTaBLRy';

final innerWalletConnector = InnerWalletConnector();

/// A `Web3MQ` shared client.
final client = Web3MQClient(apiKey, baseURL: DevEndpoint.us2);

/// A `DappConnect` shared client.
final dappConnectClient = DappConnectClient(
    apiKey,
    baseURL: DevEndpoint.jp1,
    AppMetadata('Dapp', 'for dapp testing', 'web3mq.com', const ['https://url'],
        'web3mqdemo://'));

User? _currentUser;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // The `InnerWalletConnector` is a wallet connector for the demo app,
  // which handles the `personal_sign` request by it self.
  //
  // If you want to use a different wallet to handle signatures, you can use
  // the `DemoAppWalletConnector`, which will launch other wallet on your device
  // that support the *DappConnect protocol* via Deep Link.
  // You can also customize your own implementation by implementing the
  // `WalletConnector` interface, such as changing it to call MetaMask.
  //
  client.walletConnector = innerWalletConnector;
  _currentUser = await CacheHelper.loadUser();
  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.client});

  /// Instance of [Web3MQClient] we created earlier.
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
