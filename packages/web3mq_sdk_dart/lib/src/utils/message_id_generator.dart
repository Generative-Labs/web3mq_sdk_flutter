import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:pointycastle/digests/sha3.dart';

class MessageIdGenerator {
  static String generate(
      String userId, String topic, int timestamp, Uint8List payload) {
    var sha3_224 = SHA3Digest(224);
    final userIdBytes = Uint8List.fromList(utf8.encode(userId));
    sha3_224.update(userIdBytes, 0, userIdBytes.length);
    final topicBytes = Uint8List.fromList(utf8.encode(topic));
    sha3_224.update(topicBytes, 0, topicBytes.length);
    final timestampBytes =
        Uint8List.fromList(utf8.encode(timestamp.toString()));
    sha3_224.update(timestampBytes, 0, timestampBytes.length);
    sha3_224.update(payload, 0, payload.length);
    final digest = Uint8List(sha3_224.digestSize);
    final len = sha3_224.doFinal(digest, 0);
    return hex.encode(digest.sublist(0, len));
  }
}
