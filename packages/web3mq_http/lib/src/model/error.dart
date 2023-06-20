import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:web3mq_core/models.dart';

import '../service/responses.dart';

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
  factory Web3MQNetworkError.fromDioError(DioException error) {
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
