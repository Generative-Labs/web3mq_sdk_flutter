import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:pointycastle/api.dart';
import 'package:test/test.dart';

void main() {
  group('A group of signer tests', () {
    test('KeyPair Generation Test', () async {
      final alg = Ed25519();
      final keyPair = await alg.newKeyPair();
      final privateKeyBytes = await keyPair.extractPrivateKeyBytes();

      final keyPairFromSeed = await alg.newKeyPairFromSeed(privateKeyBytes);
      expect(keyPair, equals(keyPairFromSeed));

      final keyPairFromNew = await alg.newKeyPair();
      expect(keyPair, isNot(equals(keyPairFromNew)));

      final publicKey1 = await keyPair.extractPublicKey();
      final publicKey2 = await keyPairFromSeed.extractPublicKey();

      expect(publicKey1, equals(publicKey2));
    });

    test("description", () async {
      final raw =
          "\$web3mqeth:0xb0597dee2c652b6cd194e444cdff0476bcb543731123web3mq\$";
      final rawBytes = utf8.encode(raw);
      print("raw bytes: $rawBytes");

      final sha224 = Digest("SHA3-224");
      final hashed = sha224.process(Uint8List.fromList(rawBytes));
      // final hashed = await Hmac.sha224().hashAlgorithm.hash(rawBytes);
      // final hashed = await Sha224().hash(rawBytes);
      print("hashed bytes:$hashed");
      final magicString = base64Encode(hashed);
      print("magicString: $magicString");
    });

    tearDown(() {});
  });
}
