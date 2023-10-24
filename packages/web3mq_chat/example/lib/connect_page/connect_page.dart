import 'package:flutter/material.dart';
import 'package:web3mq/web3mq.dart';

import '../chat_pages/chat_list_page.dart';
import '../main.dart';
import '../utils/alert_utils.dart';

class ConnectPage extends StatefulWidget {
  const ConnectPage({super.key, required this.title});

  final String title;

  @override
  State<ConnectPage> createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  // Get did by wallet connector
  DID? _currentDid;

  // Get _userId by userInfo api
  String? _userId;

  // Get credentials by generateSessionKey
  User? _sessionKey;

  ConnectionStatus _connectionStatus = ConnectionStatus.disconnected;

  _ConnectPageState() {
    // listen connection status
    client.connectionStatusStream.listen((status) {
      setState(() {
        _connectionStatus = status;
      });
    });
  }

  void _connectWallet() async {
    try {
      _showLoading();
      final wallet = await walletConnector.connectWallet();
      _hideLoading();

      // if wallet.dids.first has value, set it to _currentDid
      final theDid = wallet.dids.firstOrNull;
      setState(() {
        _currentDid = theDid;
      });
      if (theDid == null) {
        throw Exception('you should connect wallet first');
      }
      // get userId by userInfo api
      final userInfo = await client.userInfo(theDid.type, theDid.value);
      setState(() {
        _userId = userInfo?.userId;
      });
    } catch (e) {
      _hideLoading();
      _showToast(e.toString());
    }
  }

  void _onGenerateSesionKey() async {
    if (_currentDid == null) {
      throw Exception('you should connect wallet first');
    }

    // Judge Should create credentials
    if (_userId == null || (_userId?.isEmpty ?? true)) {
      _createSessionKeyWhenUserNotExist();
    } else {
      _generateSessionKeyWhenUserExist();
    }
  }

  // create session key when user not exist, you should create credentials first.
  void _createSessionKeyWhenUserNotExist() async {
    final password = await inputPassword('Create password');
    if (password == null) return;
    try {
      final credentials =
          await client.createCredentials(_currentDid!, password);
      final createdSessionKey = await client.generateSessionKey(
          _currentDid!, credentials.privateKey, const Duration(days: 7));
      setState(() {
        _sessionKey = createdSessionKey;
        _userId = credentials.userId;
      });
    } catch (e) {
      // If any errors
      if (!context.mounted) return;
      await AlertUtils.showText(e.toString(), context);
    }
  }

  // Generate session key when user exist, you could generate session key with
  // password or privateKey.
  void _generateSessionKeyWhenUserExist() async {
    // user exist, generate session key with password.
    final password = await inputPassword('Input your password');
    if (password == null) return;
    // If you cached the privateKey, you can use it to generate session
    // key by `client.generateSessionKey(_currentDid!, privateKey, duration)`.
    // Or you can use password to generate session key.
    final createdSessionKey = await client.generateSessionKeyWithPassword(
        _currentDid!, password, const Duration(days: 7));
    setState(() {
      _sessionKey = createdSessionKey;
    });
  }

  void _onConnectClient() async {
    if (_sessionKey == null) {
      throw Exception('you should generate session key first');
    }
    await client.connectUser(_sessionKey!);
  }

  Future<String?> inputPassword(String title) {
    return AlertUtils.showTextField(title, 'password', context);
  }

  void _toChatListPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ChatsPage(title: 'Chats'),
      ),
    );
  }

  void _showLoading() {
    if (context.mounted) {
      // show a loading dialog
      AlertUtils.showLoading(context);
    }
  }

  void _hideLoading() {
    if (context.mounted) {
      // show a loading dialog
      AlertUtils.hideLoading(context);
    }
  }

  void _showToast(String text) {
    if (!context.mounted) return;
    AlertUtils.showText(text, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Connection status: ${_connectionStatus.name}',
              ),
              const SizedBox(height: 16),
              Text('DID Type: ${_currentDid?.type ?? ''}'),
              const SizedBox(height: 16),
              Text('DID Value: ${_currentDid?.value ?? ''}'),
              const SizedBox(height: 16),
              Text('UserId: $_userId'),
              const SizedBox(height: 16),
              Text('SessionKey: ${_sessionKey?.sessionKey ?? ''}'),
              const SizedBox(height: 16),
              ElevatedButton(
                  onPressed: _connectWallet,
                  child: const Text('1. Connect Wallet')),
              ElevatedButton(
                  onPressed: _onGenerateSesionKey,
                  child: const Text('2. Generate Session Key')),
              ElevatedButton(
                  onPressed: _sessionKey != null ? _onConnectClient : null,
                  child: const Text('3. Connect Client')),
              _connectionStatus == ConnectionStatus.connected
                  ? ElevatedButton(
                      onPressed: _toChatListPage,
                      child: const Text('Go to Chat List Page'))
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
