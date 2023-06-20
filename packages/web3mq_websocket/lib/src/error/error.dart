import 'dart:io';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Base error class.
class Web3MQError with EquatableMixin implements Exception {
  ///
  const Web3MQError(this.message);

  /// Error message
  final String message;

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'Web3MQError(message: $message)';
}

/// Error when websocket failed.
class Web3MQWebSocketError extends Web3MQError {
  ///
  const Web3MQWebSocketError(super.message);

  ///
  factory Web3MQWebSocketError.fromAnyMessage(String message) {
    return Web3MQWebSocketError(message);
  }

  ///
  factory Web3MQWebSocketError.fromWebSocketChannelError(
    WebSocketChannelException error,
  ) {
    final message = error.message ?? "";
    return Web3MQWebSocketError(message);
  }

  ///
  factory Web3MQWebSocketError.fromWebSocketError(
    WebSocketException error,
  ) {
    final message = error.message;
    return Web3MQWebSocketError(message);
  }
}

enum Web3MQErrorCode { idle }

const _errorCodeWithDescription = {
  Web3MQErrorCode.idle: MapEntry(1000, 'Unauthorised, token not defined'),
};

///
Web3MQErrorCode? errorCodeFromCode(int code) => _errorCodeWithDescription.keys
    .firstWhereOrNull((key) => _errorCodeWithDescription[key]!.key == code);

///
extension ChatErrorCodeX on Web3MQErrorCode {
  ///
  String get message => _errorCodeWithDescription[this]!.value;

  ///
  int get code => _errorCodeWithDescription[this]!.key;
}
