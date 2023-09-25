import 'package:flutter/material.dart';
import 'package:web3mq_dapp_connect/dapp_connect.dart';
import 'main.dart';

class TestsPage extends StatefulWidget {
  const TestsPage({super.key});

  @override
  State<StatefulWidget> createState() => _TestsPageState();
}

class _TestsPageState extends State<TestsPage> {
  String _title = '';

  String _currentSession = '';

  String _signature = '';

  @override
  void initState() {
    super.initState();
    _listenConnectionStatus();
  }

  void _listenConnectionStatus() {
    dappConnectClient.connectionStatusStream.listen((status) {
      // handle the new status
      switch (status) {
        case ConnectionStatus.connected:
          setState(() {
            _title = 'Connected';
          });
          break;
        case ConnectionStatus.connecting:
          setState(() {
            _title = 'Connecting...';
          });
          break;
        case ConnectionStatus.disconnected:
          setState(() {
            _title = 'Disconnected';
          });
          break;
        default:
      }
    });
  }

  void _connectWallet() async {
    //
    final requiredNamespaces = {
      'eip255': ProposalNamespace(
          chains: const {"eip155:1", "eip155:10"},
          methods: const {'personal_sign'},
          events: const {"chainChanged", "accountsChanged"})
    };
    try {
      final session = await dappConnectClient.connectWallet(requiredNamespaces);
      setState(() {
        _currentSession = session.toJson().toString();
      });
    } on DappConnectError {
      // handle timeout error
      setState(() {
        _currentSession = 'timeout';
      });
    } on RPCError catch (e) {
      // handle rpc error
      setState(() {
        _currentSession = '${e.code}, ${e.message}';
      });
    }
  }

  void _connectWebsocket() async {
    try {
      await dappConnectClient.connectUser();
    } catch (e) {
      print(e);
    }
  }

  void _sendRequest() async {
    final sessions = await dappConnectClient.sessions;
    final currentSession = sessions.last;
    final accountString = currentSession.namespaces.values.first.accounts.first;
    final account = Account.from(accountString);

    try {
      final signature = await dappConnectClient.personalSign(
          'message', account.address, currentSession.topic);
      setState(() {
        _signature = signature;
      });
    } on DappConnectError {
      // handle timeout error
      setState(() {
        _signature = 'timeout';
      });
    } on RPCError catch (e) {
      // handle rpc error
      setState(() {
        _signature = '${e.code}, ${e.message}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Session:'),
            Text(_currentSession),
            const SizedBox(height: 32),
            const Text('Signature:'),
            Text(_signature),
            TextButton(
              onPressed: _connectWebsocket,
              child: const Text("Connect Websocket"),
            ),
            TextButton(
              onPressed: _connectWallet,
              child: const Text("Connect Wallet"),
            ),
            TextButton(
              onPressed: _sendRequest,
              child: const Text("Send Request"),
            ),
          ],
        ),
      ),
    );
  }
}
