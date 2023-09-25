import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'session.dart';

part 'rpc_request.g.dart';

///
@JsonSerializable()
class RPCRequest extends Equatable {
  ///
  final String id;

  ///
  final String jsonrpc;

  ///
  final String method;

  ///
  @JsonKey(disallowNullValue: true, includeIfNull: false)
  final dynamic params;

  /// Create a new instance
  RPCRequest(this.id, this.method, this.params, {this.jsonrpc = '2.0'});

  /// Create a new instance from a json
  factory RPCRequest.fromJson(Map<String, dynamic> json) =>
      _$RPCRequestFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$RPCRequestToJson(this);

  @override
  List<Object?> get props => [id, jsonrpc, method, params];

  ///
  factory RPCRequest.from(String id, String method, Map<String, dynamic> map) {
    final paramsJson = jsonEncode(map);
    final paramsBytes = utf8.encode(paramsJson);
    return RPCRequest(id, method, paramsBytes);
  }

  /// Convert to bytes
  List<int> toBytes() {
    return utf8.encode(jsonEncode(toJson()));
  }
}

///
@JsonSerializable(explicitToJson: true, includeIfNull: false, anyMap: true)
class SessionProposalRPCRequest {
  ///
  final String id;

  ///
  final String jsonrpc;

  ///
  final String method;

  ///
  final SessionProposalContent? params;

  ///
  SessionProposalRPCRequest(this.id, this.method, this.params,
      {this.jsonrpc = '2.0'});

  /// Create a new instance from a json
  factory SessionProposalRPCRequest.fromJson(Map<String, dynamic> json) =>
      _$SessionProposalRPCRequestFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$SessionProposalRPCRequestToJson(this);
}
