import 'dart:typed_data';

import 'package:web3mq_core/models.dart';
import 'package:web3mq_http/src/model/pagination.dart';
import 'package:web3mq_http/web3mq_http.dart';

void main() {
  final service = Web3MQService('{apiKey}');
  final userId = '';
  final did = DID('type', 'value');
  final privateKey = Uint8List.fromList([]);
  service.connectUser(User(userId, did, privateKey));
  service.chat.queryChannels(Pagination(size: 20));
}
