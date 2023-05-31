import 'package:dio/dio.dart';

import '../error/error.dart';

/// Error class specific to Web3MQ and Dio
class Web3MQDioError extends DioError {
  /// Initialize a web3mq dio error
  Web3MQDioError({
    required this.error,
    required super.requestOptions,
    super.response,
    super.type,
  }) : super(
          error: error,
        );

  @override
  // ignore: overridden_fields
  final Web3MQNetworkError error;
}
