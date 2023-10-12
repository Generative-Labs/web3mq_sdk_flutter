import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart' as cry;

import '../model/error.dart';

///
abstract class RequestSigner {
  ///
  void connectUser(String userId, String sessionKey);

  ///
  void disconnectUser();

  ///
  Future<RequestSignedResult> sign(String? parameter);
}

///
abstract class RequestSignedResult {
  ///
  String get signature;

  ///
  String get userId;

  ///
  DateTime get time;
}

class Web3MQRequestSinedResult implements RequestSignedResult {
  ///
  @override
  String signature;

  ///
  @override
  String userId;

  ///
  @override
  DateTime time;

  ///
  Web3MQRequestSinedResult(this.signature, this.userId, this.time);
}

///
class Web3MQRequestSigner implements RequestSigner {
  String? sessionKey;

  String? userId;

  cry.SimpleKeyPair? _keyPair;

  ///
  @override
  Future<RequestSignedResult> sign(String? parameter) async {
    final currentPrivateKey = sessionKey;
    final currentUserId = userId;
    if (null == currentUserId || currentPrivateKey == null) {
      throw Web3MQError("User is not connected");
    }
    final currentPrivateKeyBytes = hex.decode(currentPrivateKey);
    final algorithm = cry.Ed25519();
    final aNewkeyPair =
        await algorithm.newKeyPairFromSeed(currentPrivateKeyBytes);
    DateTime time = DateTime.now();
    String raw = "$userId$parameter${time.millisecondsSinceEpoch}";
    final signature =
        await algorithm.sign(utf8.encode(raw), keyPair: aNewkeyPair);
    return Web3MQRequestSinedResult(
        base64Encode(signature.bytes), currentUserId, time);
  }

  @override
  void connectUser(String userId, String sessionKey) {
    this.sessionKey = sessionKey;
    this.userId = userId;
  }

  @override
  void disconnectUser() {
    userId = null;
    sessionKey = null;
  }
}
