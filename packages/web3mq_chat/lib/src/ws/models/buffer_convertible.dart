import 'dart:typed_data';

import 'package:protobuf/protobuf.dart';
import 'package:web3mq/src/error/error.dart';

enum WSCommandType {
  chatReq(code: 1),
  connectRequest(code: 2),
  connectResponse(code: 3),
  message(code: 16),
  notificationList(code: 20),
  messageSendingStatusUpdate(code: 21),
  messageStatusUpdate(code: 22),
  ping(code: 128),
  pong(code: 129),
  bridgeConnectRequest(code: 100),
  bridgeConnectResponse(code: 101);

  const WSCommandType({
    required this.code,
  });

  factory WSCommandType.fromCode(int code) {
    switch (code) {
      case 1:
        return WSCommandType.chatReq;
      case 2:
        return WSCommandType.connectRequest;
      case 3:
        return WSCommandType.connectResponse;
      case 16:
        return WSCommandType.message;
      case 20:
        return WSCommandType.notificationList;
      case 21:
        return WSCommandType.messageSendingStatusUpdate;
      case 22:
        return WSCommandType.messageStatusUpdate;
      case 128:
        return WSCommandType.ping;
      case 129:
        return WSCommandType.pong;
      case 100:
        return WSCommandType.bridgeConnectRequest;
      case 101:
        return WSCommandType.bridgeConnectResponse;
      default:
        throw Web3MQError("Invalid command code");
    }
  }

  final int code;
}

abstract class Web3MQWebSocketMessage {
  ///
  WSCommandType get commandType;
}

mixin Web3MQBufferConvertible on Web3MQWebSocketMessage {
  GeneratedMessage toProto3Object() {
    throw UnimplementedError();
  }

  ///
  Uint8List toBuffer() {
    final categoryType = 10;
    var resultBytes = <int>[];
    resultBytes.add(categoryType);
    resultBytes.add(commandType.code);
    resultBytes.addAll(toProto3Object().writeToBuffer());
    return Uint8List.fromList(resultBytes);
  }
}
