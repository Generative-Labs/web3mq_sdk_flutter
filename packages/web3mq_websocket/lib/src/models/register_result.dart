import 'package:web3mq_core/models.dart';

///
@Deprecated("Use [Credentials] instead")
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

