// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppMetadata _$AppMetadataFromJson(Map json) => AppMetadata(
      json['name'] as String?,
      json['description'] as String?,
      json['url'] as String?,
      _nullableListFromJson(json['icons']),
      json['redirect'] as String?,
    );

Map<String, dynamic> _$AppMetadataToJson(AppMetadata instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('name', instance.name);
  writeNotNull('description', instance.description);
  writeNotNull('url', instance.url);
  writeNotNull('icons', instance.icons);
  writeNotNull('redirect', instance.redirect);
  return val;
}
