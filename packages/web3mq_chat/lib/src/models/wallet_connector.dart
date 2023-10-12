import 'dart:async';

import 'models.dart';

///
class Wallet {
  /// account_id should supports CAIP-10
  List<String> accounts = [];

  /// Gets the list of DIDs.
  List<DID> get dids =>
      accounts.map((e) => getDidFromAccount(Account.from(e))).toList();

  Wallet(this.accounts);

  /// Gets the DID of the given account.
  static DID getDidFromAccount(Account account) {
    // convert account.address to lower case
    return DID(_walletType(account), account.address.toLowerCase());
  }

  /// Gets the wallet type of the given account.
  static String _walletType(Account account) {
    switch (account.namespace) {
      case 'eip155':
        return 'eth';
      default:
        return account.namespace;
    }
  }
}

///
abstract class WalletConnector {
  /// Gets the signature of `personal_sign`.
  Future<String> personalSign(String message, String address,
      {String? password});

  /// Connects wallet, and gets the user wallet info.
  Future<Wallet> connectWallet();
}
