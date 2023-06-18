import 'package:web3mq_websocket/src/models/pb/message.pb.dart';

class Notification {
  final String id;

  ///
  final List<int> payload;

  /// The type of [payload].
  ///
  /// When payload is encode from json object, it should be [WSPayloadType.json],
  /// as payload is encode from text, it should be [WSPayloadType.plainText].
  final String payloadType;

  /// User id who send this message.
  final String userId;

  ///
  final String signature;

  final String topicId;

  ///
  final String cipherSuite;

  ///
  final int timestamp;

  ///
  final bool? read;

  ///
  final int? readTimestamp;

  Notification(
      this.id,
      this.payload,
      this.payloadType,
      this.userId,
      this.signature,
      this.cipherSuite,
      this.timestamp,
      this.read,
      this.readTimestamp,
      this.topicId);

  factory Notification.fromMessageItem(MessageItem item) {
    return Notification(
        item.messageId,
        item.payload,
        item.payloadType,
        item.comeFrom,
        item.fromSign,
        item.cipherSuite,
        item.timestamp.toInt(),
        item.read,
        item.readTimestamp.toInt(),
        item.contentTopic);
  }
}
