import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';

class KeyPairUtils {
  /// Gets [SimpleKeyPair] from private key hex string.
  static Future<SimpleKeyPair> keyPairFromPrivateKeyHex(String hexString) {
    final ed25519 = Ed25519();
    final hexBytes = hex.decode(hexString);
    return ed25519.newKeyPairFromSeed(hexBytes);
  }

  /// Generates private key hex string.
  static Future<String> generatePrivateKey() async {
    final keypair = await Ed25519().newKeyPair();
    final privateKey = await keypair.extractPrivateKeyBytes();
    return hex.encode(privateKey);
  }
}
