// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DID _$DIDFromJson(Map<String, dynamic> json) => DID(
      json['type'] as String,
      json['value'] as String,
    );

Map<String, dynamic> _$DIDToJson(DID instance) => <String, dynamic>{
      'type': instance.type,
      'value': instance.value,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      json['userId'] as String,
      DID.fromJson(json['did'] as Map<String, dynamic>),
      json['sessionKey'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'userId': instance.userId,
      'did': instance.did,
      'sessionKey': instance.sessionKey,
    };
