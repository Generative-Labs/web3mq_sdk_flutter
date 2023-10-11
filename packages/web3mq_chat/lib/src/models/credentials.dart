import 'package:json_annotation/json_annotation.dart';
import 'package:web3mq/src/models/did.dart';

part 'credentials.g.dart';

///
@JsonSerializable()
class Credentials {
  ///
  final String userId;

  ///
  final DID did;

  /// Main private key
  final String privateKey;

  ///
  Credentials(this.userId, this.did, this.privateKey);

  /// Create a new instance from a json
  factory Credentials.fromJson(Map<String, dynamic> json) =>
      _$CredentialsFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$CredentialsToJson(this);
}
