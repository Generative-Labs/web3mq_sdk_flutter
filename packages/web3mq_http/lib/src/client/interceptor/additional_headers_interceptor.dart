import 'package:dio/dio.dart';

/// Interceptor that sets additional headers for all requests.
class AdditionalHeadersInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers = {
      ...options.headers,
      ...Web3MQClient.additionalHeaders,
    };
    return handler.next(options);
  }
}
