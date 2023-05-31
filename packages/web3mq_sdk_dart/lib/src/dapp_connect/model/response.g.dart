// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Response _$ResponseFromJson(Map<String, dynamic> json) => Response(
      json['id'] as String,
      (json['result'] as List<dynamic>?)?.map((e) => e as int).toList(),
      json['error'] == null
          ? null
          : RPCError.fromJson(json['error'] as Map<String, dynamic>),
      json['topic'] as String,
      json['publicKey'] as String,
    );

Map<String, dynamic> _$ResponseToJson(Response instance) => <String, dynamic>{
      'id': instance.id,
      'result': instance.result,
      'error': instance.error,
      'topic': instance.topic,
      'publicKey': instance.publicKey,
    };
