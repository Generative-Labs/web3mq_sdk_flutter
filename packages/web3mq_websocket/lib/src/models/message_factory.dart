import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart';
import 'package:web3mq_websocket/src/models/pb/message.pb.dart';
import 'package:web3mq_websocket/src/models/ws_message.dart';

import '../message_id_generator.dart';
import '../private_key_utils.dart';
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
  /// Generate a [ChatMessage]
  static Future<ChatMessage> fromText(String text, String topic,
      String senderUserId, String privateKey, String nodeId,
      {bool needStore = true,
      String cipherSuite = "NONE",
      String? threadId,
      Map<String, String>? extraData}) async {
    var message = Web3MQRequestMessage(
        version: 1,
        payloadType: PayloadType.text.value,
        comeFrom: senderUserId,
        contentTopic: topic,
        cipherSuite: cipherSuite,
        needStore: needStore,
        extraData: extraData);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final payload = utf8.encode(text);
    final messageId = MessageIdGenerator.generate(
        senderUserId, topic, timestamp, Uint8List.fromList(payload));
    message.messageId = messageId;
    message.payload = payload;
    message.messageType =
        threadId != null ? MessageType.thread : MessageType.common;
    final ed25519 = Ed25519();
    final content = "$messageId$senderUserId$topic$nodeId$timestamp";
    final keyPair = await KeyPairUtils.keyPairFromPrivateKeyHex(privateKey);
    final signature =
        await ed25519.sign(utf8.encode(content), keyPair: keyPair);
    message.fromSign = base64Encode(signature.bytes);
    message.timestamp = Int64(timestamp);
    final publicKey = await keyPair.extractPublicKey();
    message.validatePubKey = base64Encode(publicKey.bytes);
    return ChatMessage(message);
  }
}
