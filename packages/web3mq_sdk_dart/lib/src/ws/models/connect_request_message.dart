import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart';
import 'package:web3mq/src/ws/models/buffer_convertible.dart';
import 'package:web3mq/src/ws/models/pb/connect.pb.dart';

///
class ConnectRequestMessage extends Web3MQWebSocketMessage
    with Web3MQBufferConvertible {
  final String nodeId;
  final String userId;
  final Int64 timestamp;
  final String signature;

  @override
  GeneratedMessage toProto3Object() {
    return ConnectCommand(
        nodeId: nodeId,
        userId: userId,
        timestamp: timestamp,
        msgSign: signature);
  }

  ConnectRequestMessage(
      this.nodeId, this.userId, this.timestamp, this.signature);

  @override
  WSCommandType get commandType => WSCommandType.connectRequest;
}

///
class BridgeConnectRequestMessage extends Web3MQWebSocketMessage
    with Web3MQBufferConvertible {
  final String nodeId;
  final String dAppId;
  final String userId;
  final Int64 timestamp;
  final String signature;

  @override
  GeneratedMessage toProto3Object() {
    return UserTempConnectCommand(
        nodeID: nodeId,
        dAppID: dAppId,
        topicID: userId,
        signatureTimestamp: timestamp,
        dAppSignature: signature);
  }

  BridgeConnectRequestMessage(
      this.nodeId, this.dAppId, this.userId, this.timestamp, this.signature);

  @override
  WSCommandType get commandType => WSCommandType.connectRequest;
}
