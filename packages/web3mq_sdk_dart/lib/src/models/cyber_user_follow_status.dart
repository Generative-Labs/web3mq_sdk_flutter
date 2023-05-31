import 'package:json_annotation/json_annotation.dart';

part 'cyber_user_follow_status.g.dart';

///
@JsonSerializable()
class CyberFollowStatus {
  ///
  final String address;

  ///
  final bool isFollowedByMe;

  ///
  CyberFollowStatus(this.address, this.isFollowedByMe);

  /// Create a new instance from a jsonƒ
  factory CyberFollowStatus.fromJson(Map<String, dynamic> json) =>
      _$CyberFollowStatusFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$CyberFollowStatusToJson(this);
}
