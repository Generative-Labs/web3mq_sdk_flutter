import 'package:json_annotation/json_annotation.dart';

part 'rpc_error.g.dart';

///
@JsonSerializable()
class RPCError {
  ///
  final int code;

  ///
  final String message;

  ///
  RPCError({required this.code, required this.message});

  /// Create a new instance from a json
  factory RPCError.fromJson(Map<String, dynamic> json) =>
      _$RPCErrorFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$RPCErrorToJson(this);

  /// Creates a new instance of `RPCError` with the `-32600` error code and the message `The JSON sent is not a valid Request object.`
  factory RPCError.invalidRequest() => RPCError(
        code: -32600,
        message: 'The JSON sent is not a valid Request object.',
      );

  /// Creates a new instance of `RPCError` with the `-32601` error code and the message `The method does not exist / is not available.`
  factory RPCError.methodNotFound() => RPCError(
        code: -32601,
        message: 'The method does not exist / is not available.',
      );

  /// Creates a new instance of `RPCError` with the `-32602` error code and the message `Invalid method parameter(s).`
  factory RPCError.invalidParams() => RPCError(
        code: -32602,
        message: 'Invalid method parameter(s).',
      );

  /// Creates a new instance of `RPCError` with the `-32603` error code and the message `Internal JSON-RPC error.`
  factory RPCError.internalError() => RPCError(
        code: -32603,
        message: 'Internal JSON-RPC error.',
      );
}
