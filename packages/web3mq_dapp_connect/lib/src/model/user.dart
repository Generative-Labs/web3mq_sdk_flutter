import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

///
@JsonSerializable()
class DappConnectUser {
  ///
  final String userId;

  ///
  final String sessionKey;

  ///
  DappConnectUser(this.userId, this.sessionKey);

  /// Create a new instance from a json
  factory DappConnectUser.fromJson(Map<String, dynamic> json) =>
      _$DappConnectUserFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$DappConnectUserToJson(this);
}
