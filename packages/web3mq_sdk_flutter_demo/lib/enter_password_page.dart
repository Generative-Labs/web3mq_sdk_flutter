import 'package:flutter/material.dart';
import 'package:web3mq/web3mq.dart';
import 'package:web3mq_sdk_flutter_demo/login_loading_page.dart';

import 'main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title, required this.userInfo});

  final String title;

  final UserInfo userInfo;

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final UserInfo _userInfo;

  @override
  void initState() {
    super.initState();
    _userInfo = widget.userInfo;
  }

  bool _obscureText = true;
  String _password = '';

  bool get _isButtonDisabled => _password.isEmpty;

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _handlePasswordChanged(String value) {
    setState(() {
      _password = value;
    });
  }

  Future<void> _handleLoginButtonPressed() async {
    // 登录按钮被按下的处理逻辑
    final user = await client.userWithDIDAndPassword(
        DID(_userInfo.didType, _userInfo.didValue),
        _password,
        const Duration(days: 7),
        userId: widget.userInfo.userId);
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginLoadingPage(user: user)),
    );
  }

  void _resetPassword() async {
    await _onShowResetPasswordDialog();
  }

  final TextEditingController _passwordController = TextEditingController();

  // present a dialog to enter the topic and text content
  // then call client.sendText
  Future<void> _onShowResetPasswordDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          key: UniqueKey(),
          title: const Text('Reset password'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(hintText: 'New Password'),
                  controller: _passwordController,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Reset'),
              onPressed: () {
                final newPassword = _passwordController.text;
                client
                    .resetPassword(
                        DID(widget.userInfo.didType, widget.userInfo.didValue),
                        newPassword)
                    .then((value) {
                  // reset success
                  print('debug:reset password succes');
                  _passwordController.clear();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Enter password'),
          actions: [
            TextButton(
              onPressed: _resetPassword,
              child: const Text('Change password'),
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: Container(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  onChanged: _handlePasswordChanged,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(_obscureText
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: _toggleObscureText,
                    ),
                  ),
                ),
                const SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed:
                      _isButtonDisabled ? null : _handleLoginButtonPressed,
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        )));
  }
}
