import 'package:json_annotation/json_annotation.dart';

part 'cyber_profile.g.dart';

@JsonSerializable()
class MetadataInfo {
  final String avatar;

  final String displayName;

  MetadataInfo(this.avatar, this.displayName);

  /// Create a new instance from a json
  factory MetadataInfo.fromJson(Map<String, dynamic> json) =>
      _$MetadataInfoFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$MetadataInfoToJson(this);
}

@JsonSerializable()
class Owner {
  final String address;
  final String chainID;
  Owner(this.address, this.chainID);

  /// Create a new instance from a json
  factory Owner.fromJson(Map<String, dynamic> json) => _$OwnerFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$OwnerToJson(this);
}

///
@JsonSerializable()
class CyberProfile {
  @JsonKey(name: 'profileID')
  final String id;

  ///
  final String handle;

  ///
  final String avatar;

  ///
  final bool isPrimary;

  ///
  final MetadataInfo metadataInfo;

  ///
  final Owner owner;

  ///
  CyberProfile(this.id, this.handle, this.avatar, this.isPrimary,
      this.metadataInfo, this.owner);

  /// Create a new instance from a json
  factory CyberProfile.fromJson(Map<String, dynamic> json) =>
      _$CyberProfileFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$CyberProfileToJson(this);
}
