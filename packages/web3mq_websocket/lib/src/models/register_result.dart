import 'package:web3mq_core/models.dart';

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
