// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Record _$RecordFromJson(Map<String, dynamic> json) => Record(
      json['id'] as String,
      json['topic'] as String,
      Request.fromJson(json['request'] as Map<String, dynamic>),
      json['response'] == null
          ? null
          : Response.fromJson(json['response'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RecordToJson(Record instance) => <String, dynamic>{
      'id': instance.id,
      'topic': instance.topic,
      'request': instance.request,
      'response': instance.response,
    };
