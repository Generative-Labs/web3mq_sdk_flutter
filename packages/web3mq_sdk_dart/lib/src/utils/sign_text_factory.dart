import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:pointycastle/api.dart';
import 'package:web3mq/src/api/user_api.dart';

import '../ws/models/user.dart';

///
class SignTextFactory {
  ///
  static String forSetPassword(
      String walletTypeName,
      String didValue,
      String domainUrl,
      String nonceContent,
      String formattedDateString,
      SetPasswordType type) {
    final purpase = type.purpase;
    return """
Web3MQ wants you to sign in with your $walletTypeName account:
$didValue
For Web3MQ $purpase
URI: $domainUrl
Version: 1

Nonce: $nonceContent
Issued At: $formattedDateString""";
  }

  ///
  static String forMainPrivateKey(DID did, String password) {
    final nonce = generateMainPrivateKeyNonce(did, password);
    return """
Signing this message will allow this app to decrypt messages in the Web3MQ protocol for the following address: ${did.value}. This won’t cost you anything.

If your Web3MQ wallet-associated password and this signature is exposed to any malicious app, this would result in exposure of Web3MQ account access and encryption keys, and the attacker would be able to read your messages.

In the event of such an incident, don’t panic. You can call Web3MQ’s key revoke API and service to revoke access to the exposed encryption key and generate a new one!

Nonce: $nonce""";
  }

  static String generateMainPrivateKeyNonce(DID did, String password) {
    final walletType = did.type;
    final walletAddress = did.value;
    final keyIndex = 1;
    final keyMSG = "$walletType:$walletAddress$keyIndex$password";
    final magicString = '\$web3mq${keyMSG}web3mq\$';
    final sha224 = Digest("SHA3-224");
    final hashed = sha224.process(Uint8List.fromList(utf8.encode(magicString)));
    final hexString = hex.encode(hashed);
    return base64Encode(utf8.encode(hexString));
  }
}
