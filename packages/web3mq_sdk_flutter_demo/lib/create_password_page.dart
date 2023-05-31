import 'package:flutter/material.dart';
import 'package:web3mq/web3mq.dart';
import 'main.dart';
import 'login_loading_page.dart';

class CreateUserPage extends StatefulWidget {
  const CreateUserPage({super.key, required this.title, required this.did});

  final String title;

  final DID did;

  @override
  State<StatefulWidget> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final _formKey = GlobalKey<FormState>();

  String _password = '';
  String _confirmPassword = '';

  Future<void> _onRegister() async {
    final registerResult = await client.register(widget.did, _confirmPassword);
    final user = await client.userWithDIDAndPrivateKey(
        registerResult.did, registerResult.privateKey, const Duration(days: 7),
        userId: registerResult.userId);
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginLoadingPage(user: user)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Create password',
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'please enter password';
                  } else {
                    _password = value!;
                    return null;
                  }
                },
              ),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm password',
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'please enter password';
                  } else if (value != _password) {
                    return "Passwords don't match. Please check your password inputs.";
                  } else {
                    _confirmPassword = value!;
                    return null;
                  }
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // on register
                    _onRegister();
                  }
                },
                child: const Text('Create new user'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
