import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:web3mq/src/error/error.dart';
import 'package:web3mq/src/http/web3mq_dio_error.dart';

import '../models/endpoint.dart';
import 'interceptor/additional_headers_interceptor.dart';
import 'interceptor/logging_interceptor.dart';

part 'http_client_options.dart';

class Web3MQHttpClient {
  Web3MQHttpClient(this.apiKey,
      {Dio? dio, Web3MQHttpClientOptions? options, Logger? logger})
      : _options = options ?? const Web3MQHttpClientOptions(),
        httpClient = dio ?? Dio() {
    httpClient
      ..options.baseUrl = _options.baseUrl
      ..options.receiveTimeout = _options.receiveTimeout
      ..options.connectTimeout = _options.connectTimeout
      ..options.queryParameters = {
        ..._options.queryParameters,
      }
      ..options.headers = {
        'Content-Type': 'application/json',
        ..._options.headers,
      }
      ..interceptors.addAll([
        AdditionalHeadersInterceptor(),
        if (logger != null && logger.level != Level.OFF)
          LoggingInterceptor(
            requestHeader: true,
            logPrint: (step, message) {
              switch (step) {
                case InterceptStep.request:
                  return logger.info(message);
                case InterceptStep.response:
                  return logger.info(message);
                case InterceptStep.error:
                  return logger.severe(message);
              }
            },
          ),
      ]);
  }

  /// Your project Stream Chat api key.
  final String apiKey;

  /// Your project Stream Chat ClientOptions
  final Web3MQHttpClientOptions _options;

  /// [Dio] httpClient
  /// It's been chosen because it's easy to use
  /// and supports interesting features out of the box
  /// (Interceptors, Global configuration, FormData, File downloading etc.)
  @visibleForTesting
  final Dio httpClient;

  void close({bool force = false}) => httpClient.close(force: force);

  /// Handy method to make http GET request with error parsing.
  Future<Response<T>> get<T>(
    String path, {
    Map<String, Object?>? queryParameters,
    Map<String, Object?>? headers,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await httpClient.get<T>(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );
      return response;
    } on DioError catch (error) {
      throw _parseError(error);
    }
  }

  /// Handy method to make http POST request with error parsing.
  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, Object?>? queryParameters,
    Map<String, Object?>? headers,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await httpClient.post<T>(
        path,
        queryParameters: queryParameters,
        data: data,
        options: Options(headers: headers),
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );
      return response;
    } on DioError catch (error) {
      throw _parseError(error);
    }
  }

  /// Handy method to make http DELETE request with error parsing.
  Future<Response<T>> delete<T>(
    String path, {
    Map<String, Object?>? queryParameters,
    Map<String, Object?>? headers,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await httpClient.delete<T>(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        cancelToken: cancelToken,
      );
      return response;
    } on DioError catch (error) {
      throw _parseError(error);
    }
  }

  /// Handy method to make http PATCH request with error parsing.
  Future<Response<T>> patch<T>(
    String path, {
    Object? data,
    Map<String, Object?>? queryParameters,
    Map<String, Object?>? headers,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await httpClient.patch<T>(
        path,
        queryParameters: queryParameters,
        data: data,
        options: Options(headers: headers),
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );
      return response;
    } on DioError catch (error) {
      throw _parseError(error);
    }
  }

  /// Handy method to make http PUT request with error parsing.
  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    Map<String, Object?>? queryParameters,
    Map<String, Object?>? headers,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await httpClient.put<T>(
        path,
        queryParameters: queryParameters,
        data: data,
        options: Options(headers: headers),
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );
      return response;
    } on DioError catch (error) {
      throw _parseError(error);
    }
  }

  Web3MQNetworkError _parseError(DioError err) {
    Web3MQNetworkError error;
    // locally thrown dio error
    if (err is Web3MQDioError) {
      error = err.error;
    } else {
      // real network request dio error
      error = Web3MQNetworkError.fromDioError(err);
    }
    return error..stackTrace = err.stackTrace;
  }
}
