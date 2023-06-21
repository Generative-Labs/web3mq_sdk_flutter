/// Used to avoid to serialize properties to json
// ignore: prefer_void_to_null
Null readonly(_) => null;

/// Helper class for serialization to and from json
class Serializer {
  /// Used to avoid to serialize properties to json
  static const Function readOnly = readonly;
}
