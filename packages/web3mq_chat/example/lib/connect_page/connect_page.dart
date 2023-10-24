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
  String? _userId = '';

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
    try {
      final createdSessionKey = await client.generateSessionKeyWithPassword(
          _currentDid!, password, const Duration(days: 7));
      setState(() {
        _sessionKey = createdSessionKey;
      });
    } catch (e) {
      // If any errors
      if (!context.mounted) return;
      await AlertUtils.showText(e.toString(), context);
    }
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

  final ButtonStyle _defaultButtonStyle = TextButton.styleFrom(
    foregroundColor: Colors.white,
    disabledForegroundColor: const Color.fromRGBO(143, 107, 244, 1),
    backgroundColor: const Color.fromRGBO(102, 60, 238, 1),
    // background: rgba(247, 250, 255, 1);
    disabledBackgroundColor: const Color.fromRGBO(247, 250, 255, 1),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(6)),
    ),
  );

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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                style: const TextStyle(
                    color: Colors.green,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
                'Connection status: ${_connectionStatus.name}',
              ),
              const SizedBox(height: 16),
              Text('DID Type: ${_currentDid?.type ?? ''}'),
              const SizedBox(height: 16),
              Text('DID Value: ${_currentDid?.value ?? ''}'),
              const SizedBox(height: 16),
              TextButton(
                  style: _defaultButtonStyle,
                  onPressed: _currentDid == null ? _connectWallet : null,
                  child: const Text('Connect Wallet')),
              const SizedBox(height: 16),
              //
              Text(
                  'UserId: ${_userId ?? 'The current userId is empty, which means you have not created credentials yet. Clicking the "Generate session key" button below will create credentials (including userId) and session key for you.'}'),
              const SizedBox(height: 16),
              TextButton(
                  style: _defaultButtonStyle,
                  onPressed: _currentDid != null
                      ? (_sessionKey == null ? _onGenerateSesionKey : null)
                      : null,
                  child: const Text('Generate Session Key')),
              const SizedBox(height: 16),
              Text('SessionKey: ${_sessionKey?.sessionKey ?? ''}'),
              const SizedBox(height: 16),
              TextButton(
                  style: _defaultButtonStyle,
                  onPressed: _sessionKey != null
                      ? (_connectionStatus != ConnectionStatus.connected
                          ? _onConnectClient
                          : null)
                      : null,
                  child: const Text('Connect Client')),
              const SizedBox(height: 16),
              TextButton(
                  style: _defaultButtonStyle,
                  onPressed: _connectionStatus == ConnectionStatus.connected
                      ? _toChatListPage
                      : null,
                  child: const Text('Go to Chat List Page'))
            ],
          ),
        ),
      ),
    );
  }
}
