// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'namespace.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionNamespace _$SessionNamespaceFromJson(Map<String, dynamic> json) =>
    SessionNamespace(
      (json['accounts'] as List<dynamic>).map((e) => e as String).toSet(),
      (json['methods'] as List<dynamic>).map((e) => e as String).toSet(),
      (json['events'] as List<dynamic>).map((e) => e as String).toSet(),
    );

Map<String, dynamic> _$SessionNamespaceToJson(SessionNamespace instance) =>
    <String, dynamic>{
      'accounts': instance.accounts.toList(),
      'methods': instance.methods.toList(),
      'events': instance.events.toList(),
    };

ProposalNamespace _$ProposalNamespaceFromJson(Map<String, dynamic> json) =>
    ProposalNamespace(
      chains: (json['chains'] as List<dynamic>).map((e) => e as String).toSet(),
      methods:
          (json['methods'] as List<dynamic>).map((e) => e as String).toSet(),
      events:
          (json['events'] as List<dynamic>?)?.map((e) => e as String).toSet(),
    );

Map<String, dynamic> _$ProposalNamespaceToJson(ProposalNamespace instance) =>
    <String, dynamic>{
      'chains': instance.chains.toList(),
      'methods': instance.methods.toList(),
      'events': instance.events?.toList(),
    };
