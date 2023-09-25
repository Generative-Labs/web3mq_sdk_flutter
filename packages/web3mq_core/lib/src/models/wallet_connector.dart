import 'dart:async';

///
abstract class Wallet {
  /// account_id support CAIP-10
  final List<String> accounts;

  Wallet(this.accounts);
}

///
abstract class WalletConnector {
  /// Gets the signature of `personal_sign`.
  Future<String> personalSign(String message, String address,
      {String? password});

  /// Connects wallet, and gets the user wallet info.
  Future<Wallet> connectWallet();
}
