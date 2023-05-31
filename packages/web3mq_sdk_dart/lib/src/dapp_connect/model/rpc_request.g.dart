// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rpc_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RPCRequest _$RPCRequestFromJson(Map<String, dynamic> json) => RPCRequest(
      json['id'] as String,
      json['method'] as String,
      (json['params'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$RPCRequestToJson(RPCRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'method': instance.method,
      'params': instance.params,
    };

SessionProposalRPCRequest _$SessionProposalRPCRequestFromJson(
        Map<String, dynamic> json) =>
    SessionProposalRPCRequest(
      json['id'] as String,
      json['method'] as String,
      SessionProposalContent.fromJson(json['params'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SessionProposalRPCRequestToJson(
        SessionProposalRPCRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'method': instance.method,
      'params': instance.params.toJson(),
    };
