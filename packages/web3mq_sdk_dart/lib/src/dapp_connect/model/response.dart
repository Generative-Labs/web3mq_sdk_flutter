import 'package:json_annotation/json_annotation.dart';
import 'package:web3mq/src/dapp_connect/dapp_connect_client.dart';

part 'response.g.dart';

////
@JsonSerializable()
class Response {
  ///
  final String id;

  /// The result object if there was no error invoking the RPC method.
  final dynamic result;

  /// The error object if there was an error invoking the RPC method.
  final RPCError? error;

  /// From which topic the response is coming from.
  final String topic;

  ///
  final String publicKey;

  ///
  final Participant? sender;

  Response(this.id, this.result, this.error, this.topic, this.publicKey,
      this.sender);

  /// Create a new instance from a json
  factory Response.fromJson(Map<String, dynamic> json) =>
      _$ResponseFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$ResponseToJson(this);

  ///
  factory Response.fromRpcResponse(RPCResponse response, String topic,
      String publicKeyHex, Participant? sender) {
    return Response(response.id, response.result, response.error, topic,
        publicKeyHex, sender);
  }
}
