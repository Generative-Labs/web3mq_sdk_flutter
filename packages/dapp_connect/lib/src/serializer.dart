import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';
import 'package:pointycastle/export.dart';
import '../../../../dapp_connect/lib/dapp_connect/utils/key_exchange_utils.dart';

import '../dapp_connect/storage/storage.dart';

class AesKeyResult {
  // in base64
  final List<int> secretKey;
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
    final aesResult =
        await _aesKeyFromX25519KeyPair(peerPublicKeyHex, privateKeyHex);
    final contentBytes = base64.decode(content);
    return _aesDecrypt(aesResult.secretKey, aesResult.iv, contentBytes);
  }

  @override
  Future<String> encrypt(
      List<int> content, String peerPublicKeyHex, String privateKeyHex) async {
    final aesResult =
        await _aesKeyFromX25519KeyPair(peerPublicKeyHex, privateKeyHex);
    final result =
        await _aesEncrypt(aesResult.secretKey, aesResult.iv, content);
    return base64.encode(result);
  }

  Future<AesKeyResult> _aesKeyFromX25519KeyPair(
      String peerPublicKeyHex, String privateKeyHex) async {
    final sharedKey = await _sharedSecretKey(peerPublicKeyHex, privateKeyHex);
    final extractBytes = await sharedKey.extractBytes();

    final symmetricKeyBytes =
        await _exportToHkdfDerivedSymmetricKeyBytes(extractBytes);
    final symmetricKeyBase64String = base64.encode(symmetricKeyBytes);
    final iv = symmetricKeyBase64String.substring(0, 16);
    return AesKeyResult(symmetricKeyBytes, iv);
  }

  ///
  Future<Uint8List> _aesEncrypt(
    List<int> keyBytes,
    String iv,
    List<int> content,
  ) async {
    final ivBytes = base64Decode(iv);
    final cipher = GCMBlockCipher(AESEngine());
    final params =
        ParametersWithIV(KeyParameter(Uint8List.fromList(keyBytes)), ivBytes);
    cipher.init(true, params);
    final ciphertext = cipher.process(Uint8List.fromList(content));
    return ciphertext;
  }

  ///
  Future<List<int>> _aesDecrypt(
      List<int> keyBytes, String iv, List<int> content) async {
    final ivBytes = base64Decode(iv);
    final cipher = GCMBlockCipher(AESEngine());
    final params =
        ParametersWithIV(KeyParameter(Uint8List.fromList(keyBytes)), ivBytes);
    cipher.init(false, params);
    final ciphertext = cipher.process(Uint8List.fromList(content));
    return ciphertext;
  }

  ///
  Future<SecretKey> _sharedSecretKey(
      String peerPublicKeyHex, String privateKeyHex) async {
    final algorithm = X25519();
    final x25519PrivateKeyBytes = _convertEd25519ToX25519PrivateKey(
        Uint8List.fromList(hex.decode(privateKeyHex)));
    final keyPair = await algorithm.newKeyPairFromSeed(x25519PrivateKeyBytes);
    final x25519PublicKeyBytes = _convertEd25519ToX25519PublicKey(
        Uint8List.fromList(hex.decode(peerPublicKeyHex)));
    final peerPublicKey =
        SimplePublicKey(x25519PublicKeyBytes, type: KeyPairType.x25519);
    return await algorithm.sharedSecretKey(
        keyPair: keyPair, remotePublicKey: peerPublicKey);
  }

  Uint8List _convertEd25519ToX25519PrivateKey(
      Uint8List ed25519PrivateKeyBytes) {
    return KeyExchagneUtils.skToCurve25519(ed25519PrivateKeyBytes);
  }

  Uint8List _convertEd25519ToX25519PublicKey(Uint8List ed25519PublicKeyBytes) {
    return KeyExchagneUtils.pkToCurve25519(ed25519PublicKeyBytes);
  }

  Future<Uint8List> _exportToHkdfDerivedSymmetricKeyBytes(
      List<int> secretKeyBytes) async {
    final hkdfDerivedSymmetricKeyLength = 32;
    final hkdf =
        Hkdf(hmac: Hmac.sha384(), outputLength: hkdfDerivedSymmetricKeyLength);
    final secretKey = SecretKey(secretKeyBytes);
    final key = await hkdf.deriveKey(secretKey: secretKey, nonce: Uint8List(1));
    final bytes = await key.extractBytes();
    return Uint8List.fromList(bytes);
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
