import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';
import 'package:shared_preferences/shared_preferences.dart';

///
class CyberSigningKeyStorage {
  ///
  Future<String> getSigningKeyByAddress(String address) async {
    final storage = await SharedPreferences.getInstance();
    final cacheKey = _getStorageKeyByAddress(address);
    final cachedSigningKey = storage.getString(cacheKey);
    if (null != cachedSigningKey) {
      return cachedSigningKey;
    } else {
      // No signing key found for address
      final keyPair = await Ed25519().newKeyPair();
      final privateKeyBytes = await keyPair.extractPrivateKeyBytes();
      final privateKeyHex = hex.encode(privateKeyBytes);
      return privateKeyHex;
    }
  }

  ///
  Future<String> getPublicKeyByAddress(String address) async {
    final privateKey = await getSigningKeyByAddress(address);
    final bytes = hex.decode(privateKey);
    final keyPair = await Ed25519().newKeyPairFromSeed(bytes);
    final publicKey = await keyPair.extractPublicKey();
    return hex.encode(publicKey.bytes);
  }

  Future<void> setSigningKeyByAddress(String address, String signingKey) async {
    final storage = await SharedPreferences.getInstance();
    final cacheKey = _getStorageKeyByAddress(address);
    storage.setString(cacheKey, signingKey);
  }

  ///
  Future<bool> hasSigningKeyByAddress(String address) async {
    final storage = await SharedPreferences.getInstance();
    final cacheKey = _getStorageKeyByAddress(address);
    return storage.containsKey(cacheKey);
  }

  ///
  Future<String> signWithSigningKey(String mesage, String address) async {
    final signingKey = await getSigningKeyByAddress(address);
    final keypair = await Ed25519().newKeyPairFromSeed(hex.decode(signingKey));
    final signature =
        await Ed25519().sign(utf8.encode(mesage), keyPair: keypair);
    return hex.encode(signature.bytes);
  }

  String _getStorageKeyByAddress(String address) {
    return 'signingKey_$address';
  }
}
