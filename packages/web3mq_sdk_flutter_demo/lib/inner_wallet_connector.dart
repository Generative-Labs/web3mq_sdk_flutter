import 'dart:convert';
import 'dart:typed_data';

import 'package:eth_sig_util/eth_sig_util.dart';
import 'package:eth_sig_util/util/utils.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web3mq/web3mq.dart' as web3mq;

class InnerWalletConnector implements web3mq.WalletConnector {
  final _InnerWallet _wallet = _InnerWallet();

  @override
  Future<web3mq.Wallet> connectWallet() async {
    return _wallet;
  }

  @override
  Future<String> personalSign(String message, String address,
      {String? password}) async {
    final messageData = utf8.encode(message);
    final concat = Uint8List.fromList(messageData);
    String signature = EthSigUtil.signPersonalMessage(
        privateKey: _wallet.privateKey, message: concat);
    return Future.value(signature);
  }
}

class _InnerWallet implements web3mq.Wallet {
  // It's the testing account, the password of this account is 123123,
  // you can replace your own private key here for testing.
  // Warning: care for your private key!
  final String privateKey =
      "e1ac9db61281f7b762f3da696e3f018898af12a1872fd3707c0c20c06bbbf45b";

  @override
  List<String> get accounts => ["eip155:1:$address"];

  String get address =>
      EthPrivateKey(Uint8List.fromList(hexToBytes(privateKey))).address.hex;
}
