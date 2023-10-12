import 'dart:convert';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart';
import 'package:web3mq_websocket/src/models/pb/message.pb.dart';
import 'package:web3mq_websocket/src/models/ws_message.dart';

import '../message_id_generator.dart';
import '../utils/keypair.dart';
import 'buffer_convertible.dart';

enum PayloadType {
  text(value: "text/plain; charset=utf-8"),
  bytes(value: "application/json");

  final String value;

  const PayloadType({required this.value});
}

///
class ChatMessage extends Web3MQWebSocketMessage with Web3MQBufferConvertible {
  final Web3MQRequestMessage message;

  ChatMessage(this.message);

  @override
  GeneratedMessage toProto3Object() {
    return message;
  }

  @override
  WSCommandType get commandType => WSCommandType.message;
}

/// A message factory
class MessageFactory {
  static Future<ChatMessage> _from(List<int> value, PayloadType payloadType,
      String topic, String senderUserId, Uint8List privateKey, String? nodeId,
      {bool needStore = true,
      String cipherSuite = "NONE",
      String? messageType,
      String? threadId,
      Map<String, String>? extraData}) async {
    var message = Web3MQRequestMessage(
        version: 1,
        comeFrom: senderUserId,
        contentTopic: topic,
        cipherSuite: cipherSuite,
        payloadType: payloadType.value,
        needStore: needStore,
        extraData: extraData);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final messageId = MessageIdGenerator.generate(
        senderUserId, topic, timestamp, Uint8List.fromList(value));
    message.messageId = messageId;
    message.payload = value;
    message.messageType = messageType ??
        (threadId != null ? MessageType.thread : MessageType.common);
    final content = "$messageId$senderUserId$topic$nodeId$timestamp";
    final keyPair = KeyPair(privateKey);
    final signature = await keyPair.sign(utf8.encode(content));
    message.fromSign = base64Encode(signature);
    message.timestamp = Int64(timestamp);
    message.validatePubKey = await keyPair.publicKeyBase64;
    return ChatMessage(message);
  }

  /// Generate a [ChatMessage]
  static Future<ChatMessage> fromText(String text, String topic,
      String senderUserId, Uint8List privateKey, String nodeId,
      {bool needStore = true,
      String cipherSuite = "NONE",
      String? messageType,
      String? threadId,
      Map<String, String>? extraData}) async {
    final payload = utf8.encode(text);
    return _from(
        payload, PayloadType.text, topic, senderUserId, privateKey, nodeId,
        needStore: needStore,
        cipherSuite: cipherSuite,
        messageType: messageType,
        threadId: threadId,
        extraData: extraData);
  }

  /// Generate a [ChatMessage]
  static Future<ChatMessage> fromBytes(List<int> bytes, String topic,
          String senderUserId, Uint8List privateKey, String? nodeId,
          {bool needStore = true,
          String cipherSuite = "NONE",
          String? messageType,
          String? threadId,
          Map<String, String>? extraData}) =>
      _from(bytes, PayloadType.bytes, topic, senderUserId, privateKey, nodeId,
          needStore: needStore,
          cipherSuite: cipherSuite,
          messageType: messageType,
          threadId: threadId,
          extraData: extraData);
}
