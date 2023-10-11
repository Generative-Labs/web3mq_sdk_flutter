import 'package:example/wallet_connect_v2_connector.dart';
import 'package:flutter/material.dart';
import 'package:web3mq/web3mq.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Web3MQ Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Web3MQ Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // replace your own API-Key
  static String yourApiKey = 'yourApiKey';

  final _walletConnector = WalletConnectV2Connector();

  ///
  final client = Web3MQClient(yourApiKey);

  DID? _curerntDid;

  _MyHomePageState() {
    client.walletConnector = _walletConnector;
  }

  void _connectWallet() async {
    final wallet = await _walletConnector.connectWallet();
    // if wallet.dids.first has  value, set it to _curerntDid
    if (wallet.dids.firstOrNull != null) {
      setState(() {
        _curerntDid = wallet.dids.first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _curerntDid?.type ?? '',
            ),
            Text(
              _curerntDid?.value ?? '',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _connectWallet,
        tooltip: 'Connect Wallet',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
