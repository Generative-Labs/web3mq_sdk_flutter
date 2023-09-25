// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_proposal_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionProposalResult _$SessionProposalResultFromJson(
        Map<String, dynamic> json) =>
    SessionProposalResult(
      (json['sessionNamespaces'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, SessionNamespace.fromJson(e as Map<String, dynamic>)),
      ),
      SessionProperties.fromJson(
          json['sessionProperties'] as Map<String, dynamic>),
      AppMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SessionProposalResultToJson(
        SessionProposalResult instance) =>
    <String, dynamic>{
      'sessionNamespaces':
          instance.sessionNamespaces.map((k, e) => MapEntry(k, e.toJson())),
      'sessionProperties': instance.sessionProperties.toJson(),
      'metadata': instance.metadata.toJson(),
    };
