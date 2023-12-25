import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart';
import 'package:web3mq_websocket/src/models/pb/message.pb.dart';

import 'buffer_convertible.dart';

///
class WSPayloadType {
  /// `text/plain; charset=utf-8`
  static final String plainText = 'text/plain; charset=utf-8';

  /// application/json; charset=utf-8
  static final String json = 'application/json; charset=utf-8';
}

///
class MessageType {
  /// the message type except `thead`
  static const String common = '';

  ///
  static const String thread = 'Web3MQ/thread';

  ///
  static const String bridge = 'Web3MQ/bridge';
}

///
class CipherSuit {
  /// NONE
  static const String none = 'NONE';

  /// X25519/AES-GCM_SHA384
  static const String x25519 = 'X25519/AES-GCM_SHA384';

  static const String mls = 'MLS_128_DHKEMX25519_AES128GCM_SHA256_Ed25519';
}

/// This message is for websocket.
class WSMessage extends Web3MQWebSocketMessage with Web3MQBufferConvertible {
  /// The message ID.
  ///
  /// This is either created by Web3MQ or set client side when the message
  /// is added.
  final String id;

  /// The topic id.
  final String topicId;

  /// The node id.
  final String nodeId;

  /// User id who send this message.
  final String userId;

  /// Whether store the message at Web3MQ network.
  final bool needStore;

  /// The type of [payload].
  ///
  /// When payload is encode from json object, it should be [WSPayloadType.json],
  /// as payload is encode from text, it should be [WSPayloadType.plainText].
  final String payloadType;

  /// The payload of this message.
  final Uint8List payload;

  /// Signed with [id], [userId], [topicId], [nodeId], [timestamp].
  final String signature;

  ///
  final String cipherSuite;

  /// When this message was created.
  ///
  /// Should be milliseconds since1970.
  final int timestamp;

  /// 1 by default.
  final int version;

  /// The websocket command type.
  @override
  final WSCommandType commandType;

  ///
  final String validatePubKey;

  /// The [MessageType].
  final String? messageType;

  /// The parent message id.
  final String? threadId;

  /// The extra data.
  final Map<String, String>? extraData;

  ///
  WSMessage(
      this.id,
      this.topicId,
      this.nodeId,
      this.userId,
      this.needStore,
      this.payload,
      this.signature,
      this.cipherSuite,
      this.timestamp,
      this.payloadType,
      this.version,
      this.commandType,
      this.messageType,
      this.threadId,
      this.validatePubKey,
      this.extraData);

  @override
  GeneratedMessage toProto3Object() {
    return Web3MQRequestMessage(
        messageId: id,
        contentTopic: topicId,
        nodeId: nodeId,
        comeFrom: userId,
        needStore: needStore,
        payload: payload,
        fromSign: signature,
        cipherSuite: cipherSuite,
        timestamp: Int64(timestamp),
        payloadType: payloadType,
        messageType: messageType,
        threadId: threadId ?? '',
        version: version,
        validatePubKey: validatePubKey,
        extraData: extraData);
  }

  factory WSMessage.fromWebSocketMessage(Web3MQRequestMessage message) {
    return WSMessage(
        message.messageId,
        message.contentTopic,
        message.nodeId,
        message.comeFrom,
        message.needStore,
        Uint8List.fromList(message.payload),
        message.fromSign,
        message.cipherSuite,
        message.timestamp.toInt(),
        message.payloadType,
        message.version,
        WSCommandType.message,
        message.messageType,
        message.threadId.isEmpty ? null : message.threadId,
        message.validatePubKey,
        message.extraData);
  }
}
