// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rpc_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RPCResponse _$RPCResponseFromJson(Map<String, dynamic> json) => RPCResponse(
      json['id'] as String,
      json['method'] as String?,
      jsonrpc: json['jsonrpc'] as String? ?? '2.0',
      result: json['result'],
      error: json['error'] == null
          ? null
          : RPCError.fromJson(json['error'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RPCResponseToJson(RPCResponse instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'jsonrpc': instance.jsonrpc,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('method', instance.method);
  writeNotNull('result', instance.result);
  writeNotNull('error', instance.error?.toJson());
  return val;
}
