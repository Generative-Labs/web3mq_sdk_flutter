import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:web3mq_websocket/src/message_signer.dart';

import 'models/connect_request_message.dart';

///
class ConnectRequestSignature {
  ///
  final String nodeId;

  ///
  final String userId;

  ///
  final Int64 timestamp;

  ///
  final String signature;

  ///
  ConnectRequestSignature(
      this.nodeId, this.userId, this.timestamp, this.signature);
}

///
class WebSocketMessageGenerator {
  ///
  static Future<ConnectRequestMessage> connectCommandMessage(
      String userId, Uint8List privateKey, MessageSinger signer) async {
    final nodeId = "nodeId";
    final ts = Int64(DateTime.now().millisecondsSinceEpoch);
    final raw = "$nodeId$userId$ts";
    final signature = await signer.sign(raw, privateKey);
    return ConnectRequestMessage(nodeId, userId, ts, signature);
  }
}
