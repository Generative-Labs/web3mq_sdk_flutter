import 'dart:convert';
import 'dart:typed_data';

///
// class BytesConverter {
//   ///
//   static dynamic from(dynamic object) {
//     if (object is Uint8List) {
//       return object;
//     } else if (object is List<int>) {
//       return Uint8List.fromList(object);
//     } else if (object is Map) {
//       String jsonStr = json.encode(object);
//       return Uint8List.fromList(utf8.encode(jsonStr));
//     } else if (object is String) {
//       return Uint8List.fromList(utf8.encode(object));
//     } else {
//       return Uint8List.fromList([]);
//     }
//   }
// }
