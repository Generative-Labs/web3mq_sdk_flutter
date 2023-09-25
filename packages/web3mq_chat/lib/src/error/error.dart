import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web3mq_core/models.dart';

import '../api/responses.dart';

/// Error when contacts request failed.
class Web3MQContactsError extends Web3MQError {
  Web3MQContactsError(super.message);

  factory Web3MQContactsError.walletConnectorNotSet() {
    return Web3MQContactsError("ContactsError: Wallet Connector Not Set");
  }

  factory Web3MQContactsError.userNotExist() {
    return Web3MQContactsError("ContactsError: User Not Exist");
  }

  factory Web3MQContactsError.syncCyberDisabled() {
    return Web3MQContactsError("ContactsError: Sync Cyber is disabled");
  }

  factory Web3MQContactsError.cyberUserNotFound() {
    return Web3MQContactsError("ContactsError: Cyber user not found");
  }
}

/// Error when sign failed.
class Web3MQSignerError extends Web3MQError {
  Web3MQSignerError(super.message);

  factory Web3MQSignerError.keyPairInvalid() {
    return Web3MQSignerError("Signer keypair invalid");
  }

  factory Web3MQSignerError.userIdInvalid() {
    return Web3MQSignerError("Signer userId invalid");
  }
}

/// Error when websocket failed.
class Web3MQWebSocketError extends Web3MQError {
  ///
  const Web3MQWebSocketError(
    super.message, {
    this.data,
  });

  /// Response body. please refer to [ErrorResponse].
  final ErrorResponse? data;

  ///
  int? get code => data?.code;

  ///
  factory Web3MQWebSocketError.fromAnyMessage(String message) {
    return Web3MQWebSocketError(message);
  }

  ///
  factory Web3MQWebSocketError.fromStreamError(Map<String, Object?> error) {
    final data = ErrorResponse.fromJson(error);
    final message = data.message ?? '';
    return Web3MQWebSocketError(message, data: data);
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

/// Error when network failed.
class Web3MQNetworkError extends Web3MQError {
  ///
  Web3MQNetworkError(
    Web3MQErrorCode errorCode, {
    int? statusCode,
    this.data,
  })  : code = errorCode.code,
        statusCode = statusCode ?? data?.code,
        super(errorCode.message);

  ///
  Web3MQNetworkError.raw({
    required this.code,
    required String message,
    this.statusCode,
    this.data,
  }) : super(message);

  ///
  factory Web3MQNetworkError.fromDioError(DioError error) {
    final response = error.response;
    ErrorResponse? errorResponse;
    final data = response?.data;
    if (data != null) {
      errorResponse = ErrorResponse.fromJson(data);
    }
    return Web3MQNetworkError.raw(
      code: errorResponse?.code ?? -1,
      message: errorResponse?.message ??
          response?.statusMessage ??
          error.message ??
          '',
      statusCode: errorResponse?.code ?? response?.statusCode,
      data: errorResponse,
    )..stackTrace = error.stackTrace;
  }

  /// Error code
  final int code;

  /// HTTP status code
  final int? statusCode;

  /// Response body. please refer to [ErrorResponse].
  final ErrorResponse? data;

  StackTrace? _stackTrace;

  ///
  set stackTrace(StackTrace? stack) => _stackTrace = stack;

  ///
  Web3MQErrorCode? get errorCode => errorCodeFromCode(code);

  ///
  bool get isRetriable => data == null;

  @override
  List<Object?> get props => [...super.props, code, statusCode];

  @override
  String toString({bool printStackTrace = false}) {
    var params = 'code: $code, message: $message';
    if (statusCode != null) params += ', statusCode: $statusCode';
    if (data != null) params += ', data: $data';
    var msg = 'Web3MQNetworkError($params)';

    if (printStackTrace && _stackTrace != null) {
      msg += '\n$_stackTrace';
    }
    return msg;
  }
}

///
extension ChatErrorCodeX on Web3MQErrorCode {
  ///
  String get message => _errorCodeWithDescription[this]!.value;

  ///
  int get code => _errorCodeWithDescription[this]!.key;
}
