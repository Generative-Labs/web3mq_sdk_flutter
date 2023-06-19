import 'dart:typed_data';

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
  final Uint8List privateKey;

  ///
  User(this.userId, this.did, this.privateKey);

  ///
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
