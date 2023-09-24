import 'package:web3mq/src/ws/models/user.dart';

///
class RegisterResult {
  ///
  final String userId;

  ///
  final DID did;

  /// Main private key
  final String privateKey;

  ///
  RegisterResult(this.userId, this.did, this.privateKey);
}
