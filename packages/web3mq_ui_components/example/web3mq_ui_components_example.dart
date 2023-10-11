import 'package:flutter/material.dart';
import 'package:web3mq/web3mq.dart';
import 'package:web3mq_ui_components/web3mq_ui_components.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Create a new instance of [StreamChatClient] passing the apikey obtained
  /// from your project dashboard.
  final client = Web3MQClient(
    's2dxdhpxd94g',
  );

  final user = User('userId', DID('', ''), 'sessionKey');

  await client.connectUser(user);
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.client,
  });

  final Web3MQClient client;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        home: ChatsPage(
          title: 'title',
          client: client,
          onTapChat: (p0) {},
        ));
  }
}
