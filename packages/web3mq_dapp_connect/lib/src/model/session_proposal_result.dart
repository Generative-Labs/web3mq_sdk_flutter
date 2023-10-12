import 'dart:convert';
import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';

import 'app_metadata.dart';
import 'namespace.dart';
import 'session.dart';

part 'session_proposal_result.g.dart';

///
@JsonSerializable(explicitToJson: true, includeIfNull: false)
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
  Uint8List toBytes() {
    return Uint8List.fromList(utf8.encode(jsonEncode(toJson())));
  }
}
