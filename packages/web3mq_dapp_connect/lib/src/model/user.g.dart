// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DappConnectUser _$DappConnectUserFromJson(Map<String, dynamic> json) =>
    DappConnectUser(
      json['userId'] as String,
      json['sessionKey'] as String,
    );

Map<String, dynamic> _$DappConnectUserToJson(DappConnectUser instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'sessionKey': instance.sessionKey,
    };
