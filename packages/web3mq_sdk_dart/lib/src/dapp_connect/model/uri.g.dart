// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uri.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DappConnectURI _$DappConnectURIFromJson(Map<String, dynamic> json) =>
    DappConnectURI(
      json['topic'] as String,
      Participant.fromJson(json['proposer'] as Map<String, dynamic>),
      SessionProposalRPCRequest.fromJson(
          json['request'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DappConnectURIToJson(DappConnectURI instance) =>
    <String, dynamic>{
      'topic': instance.topic,
      'proposer': instance.proposer.toJson(),
      'request': instance.request.toJson(),
    };
