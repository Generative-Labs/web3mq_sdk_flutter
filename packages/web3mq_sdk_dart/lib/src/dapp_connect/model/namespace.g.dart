// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'namespace.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionNamespace _$SessionNamespaceFromJson(Map<String, dynamic> json) =>
    SessionNamespace(
      (json['accounts'] as List<dynamic>)
          .map((e) => Account.fromJson(e as Map<String, dynamic>))
          .toSet(),
      (json['methods'] as List<dynamic>).map((e) => e as String).toSet(),
      (json['events'] as List<dynamic>).map((e) => e as String).toSet(),
    );

Map<String, dynamic> _$SessionNamespaceToJson(SessionNamespace instance) =>
    <String, dynamic>{
      'accounts': instance.accounts.map((e) => e.toJson()).toList(),
      'methods': instance.methods.toList(),
      'events': instance.events.toList(),
    };

ProposalNamespace _$ProposalNamespaceFromJson(Map<String, dynamic> json) =>
    ProposalNamespace(
      (json['accounts'] as List<dynamic>).map((e) => e as String).toSet(),
      (json['methods'] as List<dynamic>).map((e) => e as String).toSet(),
      (json['events'] as List<dynamic>?)?.map((e) => e as String).toSet(),
    );

Map<String, dynamic> _$ProposalNamespaceToJson(ProposalNamespace instance) =>
    <String, dynamic>{
      'accounts': instance.accounts.toList(),
      'methods': instance.methods.toList(),
      'events': instance.events?.toList(),
    };
