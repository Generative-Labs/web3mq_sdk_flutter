import 'package:json_annotation/json_annotation.dart';
import 'package:web3mq/src/dapp_connect/model/app_metadata.dart';

part 'participant.g.dart';

///
@JsonSerializable()
class Participant {
  ///
  final String publicKey;

  ///
  final AppMetadata appMetadata;

  ///
  Participant(this.publicKey, this.appMetadata);

  /// Create a new instance from a json
  factory Participant.fromJson(Map<String, dynamic> json) =>
      _$ParticipantFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$ParticipantToJson(this);
}
