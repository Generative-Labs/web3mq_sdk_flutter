import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_metadata.g.dart';

List<String>? _nullableListFromJson(dynamic json) {
  if (json == null) {
    return null;
  }
  if (json is List<String>) {
    return json;
  }
  return [];
}

///
@JsonSerializable(explicitToJson: true, includeIfNull: false, anyMap: true)
class AppMetadata extends Equatable {
  ///
  final String? name;

  ///
  final String? description;

  ///
  final String? url;

  ///
  @JsonKey(fromJson: _nullableListFromJson)
  final List<String>? icons;

  ///
  final String? redirect;

  ///
  AppMetadata(this.name, this.description, this.url, this.icons, this.redirect);

  @override
  List<Object?> get props => [name, description, url, icons, redirect];

  /// Create a new instance from a json
  factory AppMetadata.fromJson(Map<String, dynamic> json) =>
      _$AppMetadataFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$AppMetadataToJson(this);
}

// class IconsConverter implements JsonConverter<List<dynamic>?, dynamic> {
//   const IconsConverter();

//   @override
//   List<dynamic>? fromJson(dynamic json) {
//     if (json == null) {
//       return null;
//     }
//     if (json is List<dynamic>) {
//       return json;
//     }
//     return [json];
//   }

//   @override
//   dynamic toJson(List<dynamic>? object) => object;
// }
