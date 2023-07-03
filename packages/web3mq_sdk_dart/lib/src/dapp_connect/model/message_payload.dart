import 'package:json_annotation/json_annotation.dart';

part 'message_payload.g.dart';

///
@JsonSerializable()
class MesasgePayload {
  ///
  final String content;

  ///
  final String publicKey;

  ///
  MesasgePayload(this.content, this.publicKey);

  /// Create a new instance from a json
  factory MesasgePayload.fromJson(Map<String, dynamic> json) =>
      _$MesasgePayloadFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$MesasgePayloadToJson(this);
}

///
@JsonSerializable(explicitToJson: true)
class DappConnectMessage {
  ///
  final MesasgePayload payload;

  ///
  final String fromTopic;

  ///
  DappConnectMessage(this.payload, this.fromTopic);

  /// Create a new instance from a json
  factory DappConnectMessage.fromJson(Map<String, dynamic> json) =>
      _$DappConnectMessageFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$DappConnectMessageToJson(this);
}
