import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:web3mq/src/models/accounts.dart';

part 'namespace.g.dart';

///
@JsonSerializable(explicitToJson: true)
class SessionNamespace extends Equatable {
  ///
  final Set<Account> accounts;

  ///
  final Set<String> methods;

  ///
  final Set<String> events;

  ///
  SessionNamespace(this.accounts, this.methods, this.events);

  /// Create a new instance from a json
  factory SessionNamespace.fromJson(Map<String, dynamic> json) =>
      _$SessionNamespaceFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$SessionNamespaceToJson(this);

  @override
  List<Object?> get props => [accounts, methods, events];
}

///
@JsonSerializable()
class ProposalNamespace extends Equatable {
  ///
  final Set<String> accounts;

  ///
  final Set<String> methods;

  ///
  final Set<String>? events;

  ///
  ProposalNamespace(this.accounts, this.methods, this.events);

  /// Create a new instance from a json
  factory ProposalNamespace.fromJson(Map<String, dynamic> json) =>
      _$ProposalNamespaceFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$ProposalNamespaceToJson(this);

  @override
  List<Object?> get props => [accounts, methods, events];
}
