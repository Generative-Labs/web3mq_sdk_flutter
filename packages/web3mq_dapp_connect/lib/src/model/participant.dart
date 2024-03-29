import 'package:json_annotation/json_annotation.dart';

import 'app_metadata.dart';

part 'participant.g.dart';

///
@JsonSerializable(explicitToJson: true, includeIfNull: false, anyMap: true)
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
