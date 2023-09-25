// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Response _$ResponseFromJson(Map<String, dynamic> json) => Response(
      json['id'] as String,
      json['result'],
      json['error'] == null
          ? null
          : RPCError.fromJson(json['error'] as Map<String, dynamic>),
      json['topic'] as String,
      json['publicKey'] as String,
      json['sender'] == null
          ? null
          : Participant.fromJson(json['sender'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ResponseToJson(Response instance) => <String, dynamic>{
      'id': instance.id,
      'result': instance.result,
      'error': instance.error,
      'topic': instance.topic,
      'publicKey': instance.publicKey,
      'sender': instance.sender,
    };
