import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';
import 'package:web3mq_dapp_connect/web3mq_dapp_connect.dart';
import 'package:web3mq_sdk_demoapp_wallet/request_modal.dart';
import 'package:web3mq_sdk_demoapp_wallet/scan_page.dart';

import 'session_proposal_modal.dart';
import 'wallet_signer.dart';

final client = DappConnectClient(
    'SwapChat:sign.iOS',
    baseURL: DevEndpoint.sg1,
    AppMetadata(
        'Web3MQ Wallet Flutter',
        'for dart dapp test',
        'web3mq.com',
        const [
          'https://pbs.twimg.com/profile_images/1536658141210890242/hHPGxrGL_400x400.jpg'
        ],
        'web3mq://'));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await client.connectUser();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    _handleIncomingLinks();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Web3MQ Wallet',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
      // routes: {
      //   '/scan': (context) => ScanPage(
      //       title: 'Scan QR Code',
      //       onScanResult: (results) => _handleScanResult(context, results)),
      // },
    );
  }

  StreamSubscription? _sub;

  /// Handle incoming links - the ones that the app will recieve from the OS
  /// while already started.
  void _handleIncomingLinks() {
    if (!kIsWeb) {
      // It will handle app links while the app is already started - be it in
      // the foreground or in the background.
      _sub = uriLinkStream.listen((Uri? uri) {
        if (!mounted) return;
        print('got uri: $uri');
        final uriString = uri.toString();
        final result = uriString.split('web3mq://?');
        final finalUrl = result.last;
        try {
          final dappConnectURI = DappConnectURI.fromUrl(finalUrl);
          client.pairURI(dappConnectURI);
        } catch (e) {
          print("debug:pairURI:error:$e");
        }
      }, onError: (Object err) {
        print("debug:_handleIncomingLinks:error:$err");
      });
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _connectionStatus = '';

  @override
  void initState() {
    super.initState();

    client.connectionStatusStream.listen((status) {
      setState(() {
        _connectionStatus = status.toString();
      });
    });

    client.sessionProposalStream.listen((proposal) {
      _presentSessionProposalModal(context, proposal);
    });

    client.requestStream.listen((request) {
      print("debug:requestStream: $request");
      _presentRequestModal(context, request);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_connectionStatus),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20.0),
          child: Text(
            client.endpoint,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Present QR Code Scanner
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return ScanPage(
                    onScanResult: (results) =>
                        _handleScanResult(context, results),
                  );
                },
              );
            },
            icon: const Icon(Icons.qr_code_scanner),
          ),
        ],
      ),
      body: const Text(''),
    );
  }

  void _handleScanResult(BuildContext context, List<String> results) {
    Navigator.pop(context);
    // we only handle the first url here.
    final url = results.first;
    print('debug:url: $url');
    if (url.isEmpty) {
      return;
    }
    final uri = DappConnectURI.fromUrl(url);
    print('debug:uri: ${uri.toJson()}');
    client.pairURI(uri);
  }

  void _presentRequestModal(BuildContext context, Request request) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return RequestModal(request, onSelectedCancel: (request) async {
          await client.sendErrorResponse(request, 500, "User rejected");
          _dismissModal();
        }, onSelectedConfirm: (request) async {
          if (request.method == RequestMethod.personalSign) {
            final paramsList = List<String>.from(request.params);
            final theMessage = paramsList[0];
            final theAddresss = paramsList[1];
            final signature = await DemoAppWalletConnector()
                .personalSign(theMessage, theAddresss);
            await client.sendSuccessResponse(request, signature);
          }
          _dismissModal();
        });
      },
    );
  }

  void _presentSessionProposalModal(
      BuildContext context, SessionProposal proposal) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SessionProposalModal(proposal,
            onSelectedCancel: (sessionProposal) async {
          await client.rejectSessionProposal(sessionProposal.id);
          _dismissModal();
        }, onSelectedConfirm: (sessionProposal) async {
          final accounts =
              sessionProposal.requiredNamespaces.values.firstOrNull?.chains;
          final methods =
              sessionProposal.requiredNamespaces.values.firstOrNull?.methods;
          final events =
              sessionProposal.requiredNamespaces.values.firstOrNull?.events;
          final defaultAccount = Account.from(DemoAppWallet().accounts.first);
          final namespaces = {
            'eip155': SessionNamespace(
                {defaultAccount.absoluteString}, methods ?? {}, events ?? {})
          };
          await client.approveSessionProposal(
              sessionProposal.id, namespaces, const Duration(days: 7));
          _dismissModal();
        });
      },
    );
  }

  void _dismissModal() {
    Navigator.pop(context, true);
  }
}
