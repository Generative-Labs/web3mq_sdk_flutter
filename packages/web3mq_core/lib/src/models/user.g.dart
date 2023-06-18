// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      json['userId'] as String,
      DID.fromJson(json['did'] as Map<String, dynamic>),
      json['privateKey'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'userId': instance.userId,
      'did': instance.did,
      'privateKey': instance.privateKeyHex,
    };
