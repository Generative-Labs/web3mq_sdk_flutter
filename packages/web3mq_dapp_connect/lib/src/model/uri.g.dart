// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uri.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DappConnectURI _$DappConnectURIFromJson(Map json) => DappConnectURI(
      json['topic'] as String,
      Participant.fromJson(Map<String, dynamic>.from(json['proposer'] as Map)),
      SessionProposalRPCRequest.fromJson(
          Map<String, dynamic>.from(json['request'] as Map)),
    );

Map<String, dynamic> _$DappConnectURIToJson(DappConnectURI instance) =>
    <String, dynamic>{
      'topic': instance.topic,
      'proposer': instance.proposer.toJson(),
      'request': instance.request.toJson(),
    };
