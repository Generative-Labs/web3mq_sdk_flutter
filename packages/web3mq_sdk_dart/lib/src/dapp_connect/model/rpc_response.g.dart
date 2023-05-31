// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rpc_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RPCResponse _$RPCResponseFromJson(Map<String, dynamic> json) => RPCResponse(
      json['id'] as String,
      json['method'] as String?,
      (json['result'] as List<dynamic>?)?.map((e) => e as int).toList(),
      json['error'] == null
          ? null
          : RPCError.fromJson(json['error'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RPCResponseToJson(RPCResponse instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'method': instance.method,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('result', instance.result);
  writeNotNull('error', instance.error);
  return val;
}
