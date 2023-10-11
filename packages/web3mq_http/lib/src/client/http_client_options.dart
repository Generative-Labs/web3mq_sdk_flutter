part of 'http_client.dart';

/// Client options to modify [Web3MQHttpClient]
class Web3MQHttpClientOptions {
  /// Instantiates a new [Web3MQHttpClientOptions]
  const Web3MQHttpClientOptions({
    required this.baseUrl,
    this.connectTimeout = const Duration(seconds: 15),
    this.receiveTimeout = const Duration(seconds: 15),
    this.queryParameters = const {},
    this.headers = const {},
  });

  /// base url to use with client.
  final String baseUrl;

  /// connect timeout, default to 6s
  final Duration connectTimeout;

  /// received timeout, default to 6s
  final Duration receiveTimeout;

  /// Common query parameters.
  ///
  /// List values use the default [ListFormat.multiCompatible].
  ///
  /// The value can be overridden per parameter by adding a [MultiParam]
  /// object wrapping the actual List value and the desired format.
  final Map<String, Object?> queryParameters;

  /// Http request headers.
  /// The keys of initial headers will be converted to lowercase,
  /// for example 'Content-Type' will be converted to 'content-type'.
  ///
  /// The key of Header Map is case-insensitive
  /// eg: content-type and Content-Type are
  /// regard as the same key.
  final Map<String, Object?> headers;
}
