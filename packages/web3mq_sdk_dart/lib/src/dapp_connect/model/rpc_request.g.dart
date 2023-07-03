// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rpc_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RPCRequest _$RPCRequestFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    disallowNullValues: const ['params'],
  );
  return RPCRequest(
    json['id'] as String,
    json['method'] as String,
    json['params'],
    jsonrpc: json['jsonrpc'] as String? ?? '2.0',
  );
}

Map<String, dynamic> _$RPCRequestToJson(RPCRequest instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'jsonrpc': instance.jsonrpc,
    'method': instance.method,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('params', instance.params);
  return val;
}

SessionProposalRPCRequest _$SessionProposalRPCRequestFromJson(
        Map<String, dynamic> json) =>
    SessionProposalRPCRequest(
      json['id'] as String,
      json['method'] as String,
      SessionProposalContent.fromJson(json['params'] as Map<String, dynamic>),
      jsonrpc: json['jsonrpc'] as String? ?? '2.0',
    );

Map<String, dynamic> _$SessionProposalRPCRequestToJson(
        SessionProposalRPCRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'jsonrpc': instance.jsonrpc,
      'method': instance.method,
      'params': instance.params.toJson(),
    };
