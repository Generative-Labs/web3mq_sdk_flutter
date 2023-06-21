import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';

///
class KeyPair {
  ///
  final Uint8List privateKey;

  ///
  KeyPair(this.privateKey);

  ///
  String get privateKeyHex {
    return _privateKeyHex ??= hex.encode(privateKey);
  }

  ///
  String get privateKeyBase64String {
    return _privateKeyBase64 ??= base64Encode(privateKey);
  }

  ///
  Future<String> get publicKeyHex async {
    return _publicKeyHex != null
        ? _publicKeyHex!
        : await _publicKeyFromPrivateKey(privateKey)
            .then((value) => hex.encode(value))
            .then((value) => _publicKeyHex = value);
  }

  ///
  Future<String> get publicKeyBase64 async {
    return _publicKeyBase64 != null
        ? _publicKeyBase64!
        : await _publicKeyFromPrivateKey(privateKey)
            .then((value) => base64Encode(value))
            .then((value) => _publicKeyBase64 = value);
  }

  ///
  String? _privateKeyHex;

  ///
  String? _privateKeyBase64;

  ///
  String? _publicKeyHex;

  ///
  String? _publicKeyBase64;

  Future<SimpleKeyPair> _keyPairFromPrivateKey(Uint8List privateKey) async {
    final ed25519 = Ed25519();
    return await ed25519.newKeyPairFromSeed(privateKey);
  }

  Future<Uint8List> _publicKeyFromPrivateKey(Uint8List privateKey) async {
    final keyPair = await _keyPairFromPrivateKey(privateKey);
    final publickey = await keyPair.extractPublicKey();
    return Uint8List.fromList(publickey.bytes);
  }
}
