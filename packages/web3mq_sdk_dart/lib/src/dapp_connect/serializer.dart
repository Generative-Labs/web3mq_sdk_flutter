import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_sodium/flutter_sodium.dart' as sodium;
import 'storage/storage.dart';

class AesKeyResult {
  final SecretKey secretKey;
  final String iv;
  AesKeyResult(this.secretKey, this.iv);
}

///
abstract class ShareKeyCoder {
  ///
  Future<String> encrypt(
      List<int> content, String peerPublicKeyHex, String privateKeyHex);

  ///
  Future<List<int>> decrypt(
      String content, String peerPublicKeyHex, String privateKeyHex);
}

class DappConnectShareKeyCoder extends ShareKeyCoder {
  ///
  @override
  Future<List<int>> decrypt(
      String content, String peerPublicKeyHex, String privateKeyHex) async {
    final aesResult = await _aes(peerPublicKeyHex, privateKeyHex);
    final aes = AesGcm.with256bits();
    final encryptedData = utf8.encode(content);
    var mac = encryptedData.sublist(encryptedData.length - 16);

    return await aes.decrypt(
      SecretBox(
        encryptedData,
        nonce: utf8.encode(aesResult.iv),
        mac: Mac(mac),
      ),
      secretKey: aesResult.secretKey,
    );
  }

  @override
  Future<String> encrypt(
      List<int> content, String peerPublicKeyHex, String privateKeyHex) async {
    final aesResult = await _aes(peerPublicKeyHex, privateKeyHex);
    final aes = AesGcm.with256bits();
    final result = await aes.encrypt(content,
        secretKey: aesResult.secretKey, nonce: utf8.encode(aesResult.iv));
    final concatenation = result.concatenation();
    return base64Encode(concatenation);
  }

  Future<AesKeyResult> _aes(
      String peerPublicKeyHex, String privateKeyHex) async {
    final sharedKey = await _sharedSecretKey(peerPublicKeyHex, privateKeyHex);
    final symmetricKeyBase64String =
        await _exportToHkdfDerivedSymmetricKey(sharedKey);
    final secretKey = SecretKey(base64.decode(symmetricKeyBase64String));
    final iv = symmetricKeyBase64String.substring(0, 16);
    return AesKeyResult(secretKey, iv);
  }

  ///
  Future<SecretKey> _sharedSecretKey(
      String peerPublicKeyHex, String privateKeyHex) async {
    final algorithm = X25519();
    final x25519PrivateKeyBytes = _convertEd25519ToX25519PrivateKey(
        Uint8List.fromList(utf8.encode(privateKeyHex)));
    final keyPair = await algorithm.newKeyPairFromSeed(x25519PrivateKeyBytes);
    final x25519PublicKeyBytes = _convertEd25519ToX25519PublicKey(
        Uint8List.fromList(utf8.encode(peerPublicKeyHex)));
    final peerPublicKey =
        SimplePublicKey(x25519PublicKeyBytes, type: KeyPairType.x25519);
    return await algorithm.sharedSecretKey(
        keyPair: keyPair, remotePublicKey: peerPublicKey);
  }

  Uint8List _convertEd25519ToX25519PrivateKey(
      Uint8List ed25519PrivateKeyBytes) {
    return sodium.Sodium.cryptoSignEd25519SkToCurve25519(
        ed25519PrivateKeyBytes);
  }

  Uint8List _convertEd25519ToX25519PublicKey(Uint8List ed25519PublicKeyBytes) {
    return sodium.Sodium.cryptoSignEd25519PkToCurve25519(ed25519PublicKeyBytes);
  }

  Future<String> _exportToHkdfDerivedSymmetricKey(SecretKey secretKey) async {
    final hkdfDerivedSymmetricKeyLength = 32;
    final hkdf =
        Hkdf(hmac: Hmac(Sha384()), outputLength: hkdfDerivedSymmetricKeyLength);
    final hkdfInfo = <int>[];

    // 使用HKDF函数导出派生密钥
    final hkdfDerivedSymmetricKey = await hkdf.deriveKey(
      secretKey: secretKey,
      info: hkdfInfo,
    );
    final bytes = await hkdfDerivedSymmetricKey.extractBytes();
    return base64Encode(bytes);
  }
}

///
class Serializer {
  ///
  final KeyStorage keyStorage;

  ///
  final ShareKeyCoder shareKeyCoder;

  ///
  Serializer(this.keyStorage, this.shareKeyCoder);

  ///
  Future<String> encrypt(
      List<int> bytes, String peerPublicKeyHex, String? privateKey) async {
    final fianlPrivateKey = privateKey ?? await keyStorage.privateKeyHex;
    return await shareKeyCoder.encrypt(
        bytes, peerPublicKeyHex, fianlPrivateKey);
  }

  ///
  Future<List<int>> decrypt(
      String content, String peerPublicKeyHex, String? privateKey) async {
    final fianlPrivateKey = privateKey ?? await keyStorage.privateKeyHex;
    return await shareKeyCoder.decrypt(
        content, peerPublicKeyHex, fianlPrivateKey);
  }
}
