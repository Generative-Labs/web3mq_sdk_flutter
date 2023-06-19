import 'package:dio/dio.dart';

/// Interceptor that sets additional headers for all requests.
class AdditionalHeadersInterceptor extends Interceptor {
  /// AdditionalHeaders
  Map<String, dynamic> additionalHeaders = {};

  ///
  AdditionalHeadersInterceptor(this.additionalHeaders);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers = {
      ...options.headers,
      ...additionalHeaders,
    };
    return handler.next(options);
  }
}
