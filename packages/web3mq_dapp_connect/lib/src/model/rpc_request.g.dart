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

SessionProposalRPCRequest _$SessionProposalRPCRequestFromJson(Map json) =>
    SessionProposalRPCRequest(
      json['id'] as String,
      json['method'] as String,
      json['params'] == null
          ? null
          : SessionProposalContent.fromJson(
              Map<String, dynamic>.from(json['params'] as Map)),
      jsonrpc: json['jsonrpc'] as String? ?? '2.0',
    );

Map<String, dynamic> _$SessionProposalRPCRequestToJson(
    SessionProposalRPCRequest instance) {
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

  writeNotNull('params', instance.params?.toJson());
  return val;
}
