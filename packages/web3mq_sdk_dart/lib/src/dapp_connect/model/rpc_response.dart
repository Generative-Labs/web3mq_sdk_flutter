import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:web3mq/src/dapp_connect/model/rpc_error.dart';

part 'rpc_response.g.dart';

// Map<String, dynamic>?
List<int> _fromBytes(dynamic result) {
  if (null == result) {
    return [];
  }
  if (result is! String) {
    result = jsonEncode(result);
  }
  return utf8.encode(result);
}

///
@JsonSerializable()
class RPCResponse extends Equatable {
  ///
  final String id;

  ///
  final String jsonrpc;

  ///
  final String? method;

  ///
  @JsonKey(includeIfNull: false, fromJson: _fromBytes)
  final List<int>? result;

  ///
  @JsonKey(includeIfNull: false)
  final RPCError? error;

  ///
  RPCResponse(this.id, this.method, this.result, this.error,
      {this.jsonrpc = '2.0'});

  /// Create a new instance from a json
  factory RPCResponse.fromJson(Map<String, dynamic> json) =>
      _$RPCResponseFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$RPCResponseToJson(this);

  @override
  List<Object?> get props => [id, jsonrpc, method, result, error];

  /// Convert to bytes
  List<int> toBytes() {
    return utf8.encode(jsonEncode(toJson()));
  }
}
