// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Participant _$ParticipantFromJson(Map<String, dynamic> json) => Participant(
      json['publicKey'] as String,
      AppMetadata.fromJson(json['appMetadata'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ParticipantToJson(Participant instance) =>
    <String, dynamic>{
      'publicKey': instance.publicKey,
      'appMetadata': instance.appMetadata,
    };
