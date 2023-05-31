import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

/// The Did info which contains [type] and [value].
@JsonSerializable()
class DID extends Equatable {
  /// The did type, eg. `eth`.
  final String type;

  /// The did value,
  ///
  /// if [type] is `eth`, then [value] should be the address
  /// of the eth wallet.
  final String value;

  ///
  DID(this.type, this.value);

  /// Create a new instance from a json
  factory DID.fromJson(Map<String, dynamic> json) => _$DIDFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$DIDToJson(this);

  @override
  List<Object?> get props => [type, value];
}

///
@JsonSerializable()
class User {
  ///
  final String userId;

  ///
  final DID did;

  ///
  final String sessionKey;

  ///
  User(this.userId, this.did, this.sessionKey);

  /// Create a new instance from a json
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

extension PublicKey on User {
  /// Public key with hex encoded.
  Future<String?> get publicKey async {
    final keyPair = await Ed25519().newKeyPairFromSeed(hex.decode(sessionKey));
    final publicKey = await keyPair.extractPublicKey();
    return hex.encode(publicKey.bytes);
  }
}
