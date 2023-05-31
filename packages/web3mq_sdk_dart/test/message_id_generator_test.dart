import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:web3mq/src/utils/message_id_generator.dart';

void main() {
  setUp(() {});

  test('test message id generate', () async {
    final String userId = 'userId';
    final String topic = 'topic';
    final int timestamp = DateTime.now().millisecondsSinceEpoch;
    final List<int> payload = [0, 1, 3, 4, 5, 8, 98, 9, 12];
    final result = MessageIdGenerator.generate(
        userId, topic, timestamp, Uint8List.fromList(payload));
    expect(result, isNotEmpty);
  });
}
