// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MesasgePayload _$MesasgePayloadFromJson(Map<String, dynamic> json) =>
    MesasgePayload(
      json['content'] as String,
      json['publicKey'] as String,
    );

Map<String, dynamic> _$MesasgePayloadToJson(MesasgePayload instance) =>
    <String, dynamic>{
      'content': instance.content,
      'publicKey': instance.publicKey,
    };

DappConnectMessage _$DappConnectMessageFromJson(Map<String, dynamic> json) =>
    DappConnectMessage(
      MesasgePayload.fromJson(json['payload'] as Map<String, dynamic>),
      json['fromTopic'] as String,
    );

Map<String, dynamic> _$DappConnectMessageToJson(DappConnectMessage instance) =>
    <String, dynamic>{
      'payload': instance.payload.toJson(),
      'fromTopic': instance.fromTopic,
    };
