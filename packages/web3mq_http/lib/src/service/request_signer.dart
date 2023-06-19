import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:web3mq_core/models.dart';

///
abstract class RequestSigner {
  ///
  void connectUser(User user);

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
  ///
  User? user;

  ///
  @override
  Future<RequestSignedResult> sign(String? parameter) async {
    final currentUser = user;
    if (null == currentUser) {
      throw Web3MQError("User is not connected");
    }
    final algorithm = Ed25519();
    final keyPair = await algorithm.newKeyPairFromSeed(currentUser.privateKey);
    DateTime time = DateTime.now();
    String raw =
        "${currentUser.userId}$parameter${time.millisecondsSinceEpoch}";
    final signature = await algorithm.sign(utf8.encode(raw), keyPair: keyPair);
    return Web3MQRequestSinedResult(
        base64Encode(signature.bytes), currentUser.userId, time);
  }

  @override
  void connectUser(User user) {
    this.user = user;
  }
}
