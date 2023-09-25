import 'package:web3mq_core/models.dart';
import 'package:web3mq_http/src/model/pagination.dart';
import 'package:web3mq_http/web3mq_http.dart';

void main() async {
  final service = Web3MQService('{apiKey}');

  // If you want to execute the registration and login interfaces,
  // we strongly recommend that you use the web3mq package.
  // Once you have the login credential User, you can use the service like above

  final aUser = User('userId', DID('type', 'value'), 'session key');
  await service.connectUser(aUser);

  // fetch chats:
  final chats = await service.chat.queryChannels(Pagination(size: 20));
  print(chats);
}
