import 'package:json_annotation/json_annotation.dart';

import 'did.dart';

part 'user.g.dart';

///
@JsonSerializable()
class User {
  ///
  final String userId;

  ///
  final DID did;

  ///
  final String privateKeyHex;

  ///
  User(this.userId, this.did, this.privateKeyHex);

  ///
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

  // // TODO： 以懒加载的方式获取 publicKeyHex
  // String get publicKey {
  //   if (null != _publicKeyHex) {
  //     return _publicKeyHex;
  //   }
  //   final keyPair = await Ed25519().newKeyPairFromSeed(hex.decode(sessionKey));
  //   return keyPair.publicKeyHex;
  // }