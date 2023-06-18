import 'package:json_annotation/json_annotation.dart';

///

part 'did.g.dart';

@JsonSerializable()
class DID {
  ///
  final String type;

  ///
  final String value;

  ///
  DID(this.type, this.value);

  ///
  factory DID.fromJson(Map<String, dynamic> json) => _$DIDFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$DIDToJson(this);
}
