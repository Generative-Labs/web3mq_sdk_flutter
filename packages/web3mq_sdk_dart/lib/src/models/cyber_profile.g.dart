// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cyber_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MetadataInfo _$MetadataInfoFromJson(Map<String, dynamic> json) => MetadataInfo(
      json['avatar'] as String,
      json['displayName'] as String,
    );

Map<String, dynamic> _$MetadataInfoToJson(MetadataInfo instance) =>
    <String, dynamic>{
      'avatar': instance.avatar,
      'displayName': instance.displayName,
    };

Owner _$OwnerFromJson(Map<String, dynamic> json) => Owner(
      json['address'] as String,
      json['chainID'] as String,
    );

Map<String, dynamic> _$OwnerToJson(Owner instance) => <String, dynamic>{
      'address': instance.address,
      'chainID': instance.chainID,
    };

CyberProfile _$CyberProfileFromJson(Map<String, dynamic> json) => CyberProfile(
      json['profileID'] as String,
      json['handle'] as String,
      json['avatar'] as String,
      json['isPrimary'] as bool,
      MetadataInfo.fromJson(json['metadataInfo'] as Map<String, dynamic>),
      Owner.fromJson(json['owner'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CyberProfileToJson(CyberProfile instance) =>
    <String, dynamic>{
      'profileID': instance.id,
      'handle': instance.handle,
      'avatar': instance.avatar,
      'isPrimary': instance.isPrimary,
      'metadataInfo': instance.metadataInfo,
      'owner': instance.owner,
    };
