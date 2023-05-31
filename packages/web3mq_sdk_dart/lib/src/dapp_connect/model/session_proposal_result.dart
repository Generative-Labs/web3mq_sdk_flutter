import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:web3mq/src/dapp_connect/model/app_metadata.dart';
import 'package:web3mq/src/dapp_connect/model/namespace.dart';
import 'package:web3mq/src/dapp_connect/model/session.dart';

part 'session_proposal_result.g.dart';

///
@JsonSerializable(explicitToJson: true)
class SessionProposalResult {
  ///
  final Map<String, SessionNamespace> sessionNamespaces;

  ///
  final SessionProperties sessionProperties;

  ///
  final AppMetadata metadata;

  SessionProposalResult(
      this.sessionNamespaces, this.sessionProperties, this.metadata);

  /// Create a new instance from a json
  factory SessionProposalResult.fromJson(Map<String, dynamic> json) =>
      _$SessionProposalResultFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$SessionProposalResultToJson(this);

  /// Create a new instance from bytes
  factory SessionProposalResult.fromBytes(List<int> bytes) {
    final json = utf8.decode(bytes);
    return SessionProposalResult.fromJson(jsonDecode(json));
  }

  /// Converts to bytes
  List<int> toBytes() {
    return utf8.encode(jsonEncode(toJson()));
  }
}