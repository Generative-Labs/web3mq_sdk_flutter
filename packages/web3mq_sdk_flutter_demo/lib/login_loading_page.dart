import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web3mq/web3mq.dart';
import 'package:web3mq_sdk_flutter_demo/cache.dart';
import 'package:web3mq_sdk_flutter_demo/home_page.dart';
import 'main.dart';

class LoginLoadingPage extends StatefulWidget {
  const LoginLoadingPage({super.key, required this.user});

  final User user;

  @override
  State<StatefulWidget> createState() => _LoginLoadingState();
}

class _LoginLoadingState extends State<LoginLoadingPage> {
  @override
  void initState() {
    super.initState();
    if (!mounted) return;

    client.connectUser(widget.user);
    client.wsConnectionStatusStream.listen((event) {
      // handle simple
      if (event == ConnectionStatus.connected) {
        CacheHelper.saveUser(widget.user);
        // MainPage
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(user: widget.user)),
            (_) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Loading"),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: const Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoActivityIndicator(),
            Padding(padding: EdgeInsets.symmetric(vertical: 6)),
            Text("Login...")
          ],
        )),
      ),
    );
  }
}
