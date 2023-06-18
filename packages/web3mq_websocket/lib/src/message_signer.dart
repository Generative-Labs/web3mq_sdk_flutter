import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

/// The message signer.
abstract class MessageSinger {
  /// Signs the message with the givien private key.
  Future<String> sign(String raw, Uint8List privateKey);
}

/// The default message signer for web3mq.
class Web3MQEd25519MessageSigner extends MessageSinger {
  ///
  @override
  Future<String> sign(String raw, Uint8List privateKey) async {
    final algorithm = Ed25519();
    final keyPair = await algorithm.newKeyPairFromSeed(privateKey);
    final signature = await algorithm.sign(utf8.encode(raw), keyPair: keyPair);
    return base64Encode(signature.bytes);
  }
}
