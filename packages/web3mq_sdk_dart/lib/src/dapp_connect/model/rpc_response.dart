import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:web3mq/src/dapp_connect/model/rpc_error.dart';

part 'rpc_response.g.dart';

// Map<String, dynamic>?
// Uint8List _fromBytes(dynamic result) {
//   if (result is Uint8List) {
//     return result;
//   } else if (result is List<int>) {
//     return Uint8List.fromList(result);
//   } else if (result is Map) {
//     String jsonStr = json.encode(result);
//     return Uint8List.fromList(utf8.encode(jsonStr));
//   } else if (result is String) {
//     return Uint8List.fromList(utf8.encode(result));
//   } else {
//     return Uint8List.fromList([]);
//   }
// }

///
@JsonSerializable(explicitToJson: true, includeIfNull: false)
class RPCResponse extends Equatable {
  ///
  final String id;

  ///
  final String jsonrpc;

  ///
  final String? method;

  ///
  @JsonKey(includeIfNull: false)
  final dynamic result;

  ///
  @JsonKey(includeIfNull: false)
  final RPCError? error;

  /// A valid response has either a result or an error, but not both.
  bool get isInvalid {
    return error == null && result == null;
  }

  ///
  RPCResponse(this.id, this.method,
      {this.jsonrpc = '2.0', this.result, this.error});

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
