// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cyber_user_follow_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CyberFollowStatus _$CyberFollowStatusFromJson(Map<String, dynamic> json) =>
    CyberFollowStatus(
      json['address'] as String,
      json['isFollowedByMe'] as bool,
    );

Map<String, dynamic> _$CyberFollowStatusToJson(CyberFollowStatus instance) =>
    <String, dynamic>{
      'address': instance.address,
      'isFollowedByMe': instance.isFollowedByMe,
    };
