import 'package:json_annotation/json_annotation.dart';

import '../model/request.dart';
import '../model/response.dart';

part 'record.g.dart';

///
@JsonSerializable()
class Record {
  ///
  final String id;

  ///
  final String topic;

  ///
  final Request request;

  ///
  final Response? response;

  ///
  Record(this.id, this.topic, this.request, this.response);

  /// Create a new instance from a json
  factory Record.fromJson(Map<String, dynamic> json) => _$RecordFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$RecordToJson(this);

  factory Record.fromRequest(Request request) =>
      Record(request.id, request.topic, request, null);

  /// Copy with
  Record copyWith({String? id, String? topic, Response? response}) {
    return Record(
      id ?? this.id,
      topic ?? this.topic,
      request,
      response ?? this.response,
    );
  }
}
