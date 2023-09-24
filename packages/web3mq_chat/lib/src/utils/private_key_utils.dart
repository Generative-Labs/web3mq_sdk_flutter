import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';

class KeyPairUtils {
  /// Gets [SimpleKeyPair] from private key hex string.
  static Future<SimpleKeyPair> keyPairFromPrivateKeyHex(
      String hexString) async {
    final ed25519 = Ed25519();
    final hexBytes = hex.decode(hexString);
    return await ed25519.newKeyPairFromSeed(hexBytes);
  }

  static Future<String> publicKeyHexFromKeyPair(SimpleKeyPair keyPair) async {
    final privateKeyBytes = await keyPair.extractPrivateKeyBytes();
    return hex.encode(privateKeyBytes);
  }

  static Future<String> publicKeyBase64FromKeyPair(
      SimpleKeyPair keyPair) async {
    final privateKeyBytes = await keyPair.extractPrivateKeyBytes();
    return base64Encode(privateKeyBytes);
  }

  /// Gets public key hex string from private key hex string.
  static Future<String> publicKeyHexFromPrivateKeyHex(String hexString) async {
    final keyPair = await keyPairFromPrivateKeyHex(hexString);
    final publicKey = await keyPair.extractPublicKey();
    return hex.encode(publicKey.bytes);
  }

  /// Generates private key hex string.
  static Future<String> generatePrivateKey() async {
    final keypair = await Ed25519().newKeyPair();
    final privateKey = await keypair.extractPrivateKeyBytes();
    return hex.encode(privateKey);
  }
}
