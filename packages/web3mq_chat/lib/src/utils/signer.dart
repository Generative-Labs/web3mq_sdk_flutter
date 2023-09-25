import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';
import 'package:fixnum/fixnum.dart';
import 'package:web3mq_core/models.dart';

import '../error/error.dart';

///
abstract class Web3MQSigner {
  ///
  Future<String> sign(String raw);
}

///
class Signer implements Web3MQSigner {
  ///
  static final Signer _instance = Signer._();

  static Signer get instance => _instance;

  Signer._();

  ///
  String? userId;

  /// [newKeyPairFromSeed]
  SimpleKeyPair? keyPair;

  ///
  String? nodeId;

  ///
  Future<void> updateUser(User? user) async {
    final finalUser = user;
    if (finalUser == null) {
      keyPair = null;
      userId = null;
    } else {
      keyPair =
          await Ed25519().newKeyPairFromSeed(hex.decode(finalUser.sessionKey));
      userId = finalUser.userId;
    }
  }

  ///
  Future<void> importPrivateKeyBytes(List<int> seed) async {
    keyPair = await Ed25519().newKeyPairFromSeed(seed);
  }

  Future<void> importPrivateKeyHexString(String hexString) async {
    keyPair = await Ed25519().newKeyPairFromSeed(hex.decode(hexString));
  }

  ///
  @override
  Future<String> sign(String raw) async {
    final keyPair = this.keyPair;
    if (keyPair == null) {
      throw Web3MQSignerError.keyPairInvalid();
    }
    final algorithm = Ed25519();
    final signature = await algorithm.sign(utf8.encode(raw), keyPair: keyPair);
    return base64Encode(signature.bytes);
  }

  Future<SignResult> signatureForRequest(String? content) async {
    final keyPair = this.keyPair;
    if (keyPair == null) {
      throw Web3MQSignerError.keyPairInvalid();
    }

    final userId = this.userId;
    if (userId == null) {
      throw Web3MQSignerError.userIdInvalid();
    }

    final finalContent = content ?? "";
    DateTime time = DateTime.now();
    String raw = "$userId$finalContent${time.millisecondsSinceEpoch}";
    final algorithm = Ed25519();
    final signature = await algorithm.sign(utf8.encode(raw), keyPair: keyPair);
    return SignResult(base64Encode(signature.bytes), time, userId);
  }

  ///
  Future<ConnectRequestSignature> signatureForConnectRequest() async {
    final userId = this.userId;
    if (userId == null) {
      throw Web3MQSignerError.userIdInvalid();
    }
    final nodeId = this.nodeId ?? "nodeId";
    final ts = Int64(DateTime.now().millisecondsSinceEpoch);
    final raw = "$nodeId$userId$ts";
    final signature = await sign(raw);
    return ConnectRequestSignature(nodeId, userId, ts, signature);
  }
}

///
class ConnectRequestSignature {
  ///
  final String nodeId;

  ///
  final String userId;

  ///
  final Int64 timestamp;

  ///
  final String signature;

  ///
  ConnectRequestSignature(
      this.nodeId, this.userId, this.timestamp, this.signature);
}

class SignResult {
  final String signature;

  final DateTime time;

  final String userId;

  SignResult(this.signature, this.time, this.userId);
}
