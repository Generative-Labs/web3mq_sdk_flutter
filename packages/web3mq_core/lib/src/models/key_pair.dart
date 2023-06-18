import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';

///
class KeyPair {
  ///
  final Uint8List privateKey;

  ///
  late final String privateKeyHex;

  ///
  KeyPair(this.privateKey);

  ///
  String get privateKeyHexString {
    return hex.encode(privateKey);
  }

  ///
  String get privateKeyBase64String {
    return base64Encode(privateKey);
  }
}
