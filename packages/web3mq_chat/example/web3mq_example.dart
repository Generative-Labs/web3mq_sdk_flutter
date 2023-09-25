import 'dart:typed_data';

import 'package:web3mq/web3mq.dart';
import 'package:web3mq_core/models.dart';

Future<void> main() async {
  final client = Web3MQClient('api-key');

  final user = User("userId", DID("type", "value"), 'session key');
  await client.connectUser(user);

  client.notificationStream.listen((event) {
    // handle with the notifications.
  });

  // send message
  client.sendText('text', 'topic');

  client.newMessageStream.listen((event) {
    // handle the new message
  });
}
