import 'package:flutter/material.dart';
import 'package:web3mq_sdk_demoapp_wallet/scan_page.dart';
import 'package:web3mq/web3mq.dart';

final dappConnectClient = DappConnectClient(
    'eKsEePNSVXTaBLRy',
    AppMetadata(
        'Dart-Wallet', 'for dart wallet test', 'web3mq.com', const [], null));

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  dappConnectClient.connectUser();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Web3MQ Wallet',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Web3MQ Wallet'),
      routes: {
        '/scan': (context) => ScanPage(
              title: 'Scan QR Code',
              onScanResult: _handleScanResult,
            ),
      },
    );
  }

  void _handleScanResult(List<String> results) {
    print(results);
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/scan');
            },
            icon: const Icon(Icons.qr_code_scanner),
          ),
        ],
      ),
      body: const Text(''),
    );
  }
}
