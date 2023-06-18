import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart';
import 'package:web3mq_websocket/src/models/pb/heartbeat.pb.dart';

import 'buffer_convertible.dart';

class PingMessage extends Web3MQWebSocketMessage with Web3MQBufferConvertible {
  final String nodeId;
  final String? userId;
  final Int64 timestamp;
  final String? msgSign;

  @override
  final WSCommandType commandType = WSCommandType.ping;

  PingMessage(
      {required this.nodeId,
      this.userId,
      required this.timestamp,
      this.msgSign});

  factory PingMessage.fromNodeId(String nodeId) {
    return PingMessage(
        nodeId: nodeId,
        timestamp: Int64(DateTime.now().millisecondsSinceEpoch));
  }

  @override
  GeneratedMessage toProto3Object() {
    return WebsocketPingCommand(
        nodeId: nodeId, userId: userId, timestamp: timestamp, msgSign: msgSign);
  }
}
