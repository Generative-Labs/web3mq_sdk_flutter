import 'package:json_annotation/json_annotation.dart';
import 'package:web3mq/src/dapp_connect/model/rpc_request.dart';

part 'request.g.dart';

///
class RequestMethod {
  ///
  static final String providerAuthorization = 'provider_authorization';

  ///
  static final String personalSign = 'provider_authorization';
}

///
@JsonSerializable()
class Request {
  ///
  final String id;

  ///
  final String method;

  ///
  final dynamic params;

  ///
  final String topic;

  ///
  final String publicKey;

  ///
  Request(this.id, this.method, this.params, this.topic, this.publicKey);

  /// Create a new instance from a json
  factory Request.fromJson(Map<String, dynamic> json) =>
      _$RequestFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$RequestToJson(this);

  ///
  factory Request.fromRpcRequest(
      RPCRequest request, String topic, String publicKeyHex) {
    return Request(
      request.id,
      request.method,
      request.params,
      topic,
      publicKeyHex,
    );
  }
}
