// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Participant _$ParticipantFromJson(Map json) => Participant(
      json['publicKey'] as String,
      AppMetadata.fromJson(
          Map<String, dynamic>.from(json['appMetadata'] as Map)),
    );

Map<String, dynamic> _$ParticipantToJson(Participant instance) =>
    <String, dynamic>{
      'publicKey': instance.publicKey,
      'appMetadata': instance.appMetadata.toJson(),
    };
