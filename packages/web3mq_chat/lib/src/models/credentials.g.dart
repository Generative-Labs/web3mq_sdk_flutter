// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credentials.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Credentials _$CredentialsFromJson(Map<String, dynamic> json) => Credentials(
      json['userId'] as String,
      DID.fromJson(json['did'] as Map<String, dynamic>),
      json['privateKey'] as String,
    );

Map<String, dynamic> _$CredentialsToJson(Credentials instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'did': instance.did,
      'privateKey': instance.privateKey,
    };
