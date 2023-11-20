import 'dart:convert';
import 'dart:typed_data';

import 'package:eth_sig_util/eth_sig_util.dart';
import 'package:eth_sig_util/util/utils.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web3mq/web3mq.dart' as web3mq;

class InnerWalletConnector implements web3mq.WalletConnector {
  // It's the testing account
  // you can replace your own private key here for testing.
  // Warning: care for your private key!
  // UserA: 6e229b5c5c3383c55f4e70e26df560b92e90f8da78da88fbc8a2701b1899f3d7
  // UserB: e1ac9db61281f7b762f3da696e3f018898af12a1872fd3707c0c20c06bbbf45b
  static const String _thePrivateKey =
      'e1ac9db61281f7b762f3da696e3f018898af12a1872fd3707c0c20c06bbbf45b';

  final _InnerWallet _wallet = _InnerWallet.fromPrivateKey(_thePrivateKey);

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

class _InnerWallet extends web3mq.Wallet {
  String privateKey;

  String get address => _getAddressFromPrivateKey(privateKey);

  _InnerWallet.fromPrivateKey(this.privateKey)

      /// The _InnerWallet only support eip155:1 chain.
      : super(['eip155:1:${_getAddressFromPrivateKey(privateKey)}']);

  static String _getAddressFromPrivateKey(String privateKey) {
    return EthPrivateKey(Uint8List.fromList(hexToBytes(privateKey)))
        .address
        .hex;
  }
}
