import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';

class CryptoUtils {
  /// Converts a private key hex to public key hex
  static Future<String> getPublicKeyHexFromPrivateKeyHex(
      String privateKeyHex) async {
    final ed25519 = Ed25519();
    final privateKeyBytes = hex.decode(privateKeyHex);
    final keyPair = await ed25519.newKeyPairFromSeed(privateKeyBytes);
    final publickey = await keyPair.extractPublicKey();
    return hex.encode(publickey.bytes);
  }
}
