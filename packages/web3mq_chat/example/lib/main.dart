// ignore_for_file: avoid_print

import 'package:example/connect_page/connect_page.dart';
import 'package:example/ffi.dart';
import 'package:example/wallet_connector/inner_wallet_connector.dart';
import 'package:example/wallet_connector/wallet_connect_v2_connector.dart';
import 'package:flutter/material.dart';
import 'package:web3mq/web3mq.dart';

// TODO: Replace your own API-Key here.
const String yourApiKey = '';

// WalletConnectV2Connector
final walletConnector = InnerWalletConnector();

///
final client =
    Web3MQClient(yourApiKey, baseURL: DevEndpoint.us2, wc: walletConnector);

void main() async {
  runApp(const MyApp());
  print('hello: ${await api.greet()}');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Web3MQ Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const ConnectPage(title: 'Web3MQ Demo Home Page'),
    );
  }
}
