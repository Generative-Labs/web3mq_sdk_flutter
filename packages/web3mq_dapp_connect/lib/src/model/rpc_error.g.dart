// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rpc_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RPCError _$RPCErrorFromJson(Map<String, dynamic> json) => RPCError(
      code: json['code'] as int,
      message: json['message'] as String,
    );

Map<String, dynamic> _$RPCErrorToJson(RPCError instance) => <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
    };
