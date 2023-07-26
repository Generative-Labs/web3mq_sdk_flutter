// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Session _$SessionFromJson(Map<String, dynamic> json) => Session(
      json['topic'] as String,
      json['pairingTopic'] as String,
      Participant.fromJson(json['selfParticipant'] as Map<String, dynamic>),
      Participant.fromJson(json['peerParticipant'] as Map<String, dynamic>),
      json['expiryDate'] as String,
      (json['namespaces'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, SessionNamespace.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$SessionToJson(Session instance) => <String, dynamic>{
      'topic': instance.topic,
      'pairingTopic': instance.pairingTopic,
      'selfParticipant': instance.selfParticipant,
      'peerParticipant': instance.peerParticipant,
      'expiryDate': instance.expiryDate,
      'namespaces': instance.namespaces,
    };

SessionProperties _$SessionPropertiesFromJson(Map<String, dynamic> json) =>
    SessionProperties(
      json['expiry'] as String,
    );

Map<String, dynamic> _$SessionPropertiesToJson(SessionProperties instance) =>
    <String, dynamic>{
      'expiry': instance.expiry,
    };

SessionProposal _$SessionProposalFromJson(Map<String, dynamic> json) =>
    SessionProposal(
      json['id'] as String,
      json['pairingTopic'] as String,
      Participant.fromJson(json['proposer'] as Map<String, dynamic>),
      (json['requiredNamespaces'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, ProposalNamespace.fromJson(e as Map<String, dynamic>)),
      ),
      SessionProperties.fromJson(
          json['sessionProperties'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SessionProposalToJson(SessionProposal instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pairingTopic': instance.pairingTopic,
      'proposer': instance.proposer.toJson(),
      'requiredNamespaces':
          instance.requiredNamespaces.map((k, e) => MapEntry(k, e.toJson())),
      'sessionProperties': instance.sessionProperties.toJson(),
    };

SessionProposalContent _$SessionProposalContentFromJson(Map json) =>
    SessionProposalContent(
      (json['requiredNamespaces'] as Map?)?.map(
        (k, e) => MapEntry(k as String,
            ProposalNamespace.fromJson(Map<String, dynamic>.from(e as Map))),
      ),
      json['sessionProperties'] == null
          ? null
          : SessionProperties.fromJson(
              Map<String, dynamic>.from(json['sessionProperties'] as Map)),
    );

Map<String, dynamic> _$SessionProposalContentToJson(
    SessionProposalContent instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('requiredNamespaces',
      instance.requiredNamespaces?.map((k, e) => MapEntry(k, e.toJson())));
  writeNotNull('sessionProperties', instance.sessionProperties?.toJson());
  return val;
}
