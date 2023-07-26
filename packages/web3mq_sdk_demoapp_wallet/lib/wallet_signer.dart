import 'dart:convert';
import 'dart:typed_data';

import 'package:eth_sig_util/eth_sig_util.dart';
import 'package:eth_sig_util/util/utils.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web3mq/web3mq.dart' as web3mq;

class DemoAppWalletConnector extends web3mq.WalletConnector {
  final DemoAppWallet _wallet = DemoAppWallet();

  @override
  Future<web3mq.Wallet> connectWallet() {
    return Future.value(_wallet);
  }

  @override
  Future<String> personalSign(String message, String address,
      {String? password}) {
    final messageData = utf8.encode(message);
    final concat = Uint8List.fromList(messageData);
    String signature = EthSigUtil.signPersonalMessage(
        privateKey: _wallet.privateKey, message: concat);
    return Future.value(signature);
  }
}

//
class DemoAppWallet implements web3mq.Wallet {
  // 1: 15fa042adf5f16dcc9f77da7bfdb896b96c73d610e1827e31a9dd0d3121ee142
  // 2: 86b0933ddbb781976548cf80ef9bbd33db86976ffffa8965867c3e88b4edce83
  // 3：7433efd5bcfc33bbea057e530f0b3e86fcdab2474f233b827e48994bdb9c9fcf
  // 4: 18b5afba7ecd83dfe42e20edc6c3d65a9351051cbd2a0e5c573b1fdf13380c2f
  // 5: 登录测试： d4714eebd6684709c6891f9ef962962175415ed78b78fb9b86a9a330b80cf541
  // 6. 登录测试5 e1ac9db61281f7b762f3da696e3f018898af12a1872fd3707c0c20c06bbbf45b
  // 7. 登录测试6 6e229b5c5c3383c55f4e70e26df560b92e90f8da78da88fbc8a2701b1899f3d7
  // groupid: group:c1e927670455e77fd474c44040b24ab60fadd170

  final String privateKey =
      "e1ac9db61281f7b762f3da696e3f018898af12a1872fd3707c0c20c06bbbf45b";

  @override
  List<String> get accounts => ["eip155:1:$address"];

  String get address =>
      EthPrivateKey(Uint8List.fromList(hexToBytes(privateKey))).address.hex;
}
