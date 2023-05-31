import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:web3mq/src/dapp_connect/model/namespace.dart';
import 'package:web3mq/src/dapp_connect/model/participant.dart';

import '../utils/id_generator.dart';

part 'session.g.dart';

///
@JsonSerializable()
class Session {
  ///
  final String topic;

  ///
  final String pairingTopic;

  ///
  final Participant selfParticipant;

  ///
  final Participant peerParticipant;

  ///
  final String expiryDate;

  ///
  final Map<String, SessionNamespace> namespaces;

  ///
  Session(this.topic, this.pairingTopic, this.selfParticipant,
      this.peerParticipant, this.expiryDate, this.namespaces);

  /// Create a new instance from a json
  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$SessionToJson(this);
}

///
@JsonSerializable()
class SessionProperties extends Equatable {
  ///
  final String expiry;

  ///
  SessionProperties(this.expiry);

  /// Create a new instance from a json
  factory SessionProperties.fromJson(Map<String, dynamic> json) =>
      _$SessionPropertiesFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$SessionPropertiesToJson(this);

  @override
  List<Object?> get props => [expiry];

  /// Create a new instance with default 7 days.
  factory SessionProperties.fromDefault() {
    return SessionProperties(
        DateTime.now().add(Duration(days: 7)).toIso8601String());
  }

  /// Create a new instance with given duration.
  factory SessionProperties.fromExpiryDuration(Duration duration) {
    return SessionProperties(DateTime.now().add(duration).toIso8601String());
  }
}

///
@JsonSerializable(explicitToJson: true)
class SessionProposal extends Equatable {
  ///
  final String id;

  /// the sender topic.
  final String pairingTopic;

  /// the proposer.
  final Participant proposer;

  ///
  final Map<String, ProposalNamespace> requiredNamespaces;

  ///
  final SessionProperties sessionProperties;

  ///
  SessionProposal(this.id, this.pairingTopic, this.proposer,
      this.requiredNamespaces, this.sessionProperties);

  /// Create a new instance from a json
  factory SessionProposal.fromJson(Map<String, dynamic> json) =>
      _$SessionProposalFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$SessionProposalToJson(this);

  @override
  List<Object?> get props =>
      [id, pairingTopic, requiredNamespaces, sessionProperties];
}

///
@JsonSerializable(explicitToJson: true)
class SessionProposalContent extends Equatable {
  ///
  final Map<String, ProposalNamespace> requiredNamespaces;

  ///
  final SessionProperties sessionProperties;

  SessionProposalContent(this.requiredNamespaces, this.sessionProperties);

  /// Create a new instance from a json
  factory SessionProposalContent.fromJson(Map<String, dynamic> json) =>
      _$SessionProposalContentFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$SessionProposalContentToJson(this);

  @override
  List<Object?> get props => [requiredNamespaces, sessionProperties];
}

///
class SessionProposalFactory {
  ///
  static SessionProposal create(
      String pairingTopic,
      Participant proposer,
      Map<String, ProposalNamespace> requiredNamespaces,
      SessionProperties sessionProperties) {
    final id = DappConnectRequestIdGenerator().next();
    return SessionProposal(
        id, pairingTopic, proposer, requiredNamespaces, sessionProperties);
  }
}
