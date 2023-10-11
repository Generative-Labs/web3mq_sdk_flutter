import 'dart:convert';
import 'dart:typed_data';

import 'package:eth_sig_util/eth_sig_util.dart';
import 'package:eth_sig_util/util/utils.dart';
import 'package:web3dart/web3dart.dart';

class DemoAppWalletConnector {
  static DemoAppWallet wallet = DemoAppWallet(
      'e1ac9db61281f7b762f3da696e3f018898af12a1872fd3707c0c20c06bbbf45b');

  Future<String> personalSign(String message, String address,
      {String? password}) {
    final messageData = utf8.encode(message);
    final concat = Uint8List.fromList(messageData);
    String signature = EthSigUtil.signPersonalMessage(
        privateKey: wallet.privateKey, message: concat);
    return Future.value(signature);
  }
}

//
class DemoAppWallet {
  String privateKey;

  List<String> accounts = [];

  DemoAppWallet(this.privateKey) {
    accounts = ["eip155:1:$privateKey"];
  }

  String get address =>
      EthPrivateKey(Uint8List.fromList(hexToBytes(privateKey))).address.hex;
}
