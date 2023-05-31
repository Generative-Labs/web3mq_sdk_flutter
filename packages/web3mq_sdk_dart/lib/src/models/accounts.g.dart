// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accounts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Account _$AccountFromJson(Map<String, dynamic> json) => Account(
      json['namespace'] as String,
      json['reference'] as String,
      json['address'] as String,
    );

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      'namespace': instance.namespace,
      'reference': instance.reference,
      'address': instance.address,
    };
