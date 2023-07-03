// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Request _$RequestFromJson(Map<String, dynamic> json) => Request(
      json['id'] as String,
      json['method'] as String,
      json['params'],
      json['topic'] as String,
      json['publicKey'] as String,
    );

Map<String, dynamic> _$RequestToJson(Request instance) => <String, dynamic>{
      'id': instance.id,
      'method': instance.method,
      'params': instance.params,
      'topic': instance.topic,
      'publicKey': instance.publicKey,
    };
