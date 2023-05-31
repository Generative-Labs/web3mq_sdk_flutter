import 'package:json_annotation/json_annotation.dart';
import 'package:web3mq/src/dapp_connect/model/rpc_response.dart';

import 'rpc_error.dart';

part 'response.g.dart';

////
@JsonSerializable()
class Response {
  ///
  final String id;

  /// The result object if there was no error invoking the RPC method.
  final List<int>? result;

  /// The error object if there was an error invoking the RPC method.
  final RPCError? error;

  ///
  final String topic;

  ///
  final String publicKey;

  Response(this.id, this.result, this.error, this.topic, this.publicKey);

  /// Create a new instance from a json
  factory Response.fromJson(Map<String, dynamic> json) =>
      _$ResponseFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$ResponseToJson(this);

  ///
  factory Response.fromRpcResponse(
      RPCResponse response, String topic, String publicKeyHex) {
    return Response(
        response.id, response.result, response.error, topic, publicKeyHex);
  }
}
