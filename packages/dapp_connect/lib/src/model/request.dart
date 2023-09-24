import 'package:json_annotation/json_annotation.dart';
import 'participant.dart';
import 'rpc_request.dart';

part 'request.g.dart';

///
class RequestMethod {
  ///
  static final String providerAuthorization = 'provider_authorization';

  ///
  static final String personalSign = 'personal_sign';
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
  final Participant? sender;

  ///
  Request(this.id, this.method, this.params, this.topic, this.publicKey,
      this.sender);

  /// Create a new instance from a json
  factory Request.fromJson(Map<String, dynamic> json) =>
      _$RequestFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$RequestToJson(this);

  ///
  factory Request.fromRpcRequest(RPCRequest request, String topic,
      String publicKeyHex, Participant? sender) {
    return Request(request.id, request.method, request.params, topic,
        publicKeyHex, sender);
  }
}
