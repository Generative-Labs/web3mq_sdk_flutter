import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';

///
class KeyPair {
  final List<int> privateKey;

  late final Future<SimpleKeyPair> keyPair;

  KeyPair(this.privateKey) : keyPair = Ed25519().newKeyPairFromSeed(privateKey);

  ///
  String get privateKeyHexString {
    return hex.encode(privateKey);
  }

  ///
  String get privateKeyBase64String {
    return base64Encode(privateKey);
  }
}
