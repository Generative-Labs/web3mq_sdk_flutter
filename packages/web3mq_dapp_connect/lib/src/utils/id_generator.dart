import 'dart:convert';
import 'dart:math';

import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';

///
abstract class RequestIdGenerator {
  ///
  String next();
}

abstract class UserIdGenerator {
  ///
  Future<String> create(String appId, String publicKeyBase64String);
}

///
class DappConnectRequestIdGenerator extends RequestIdGenerator {
  ///
  @override
  String next() {
    final timestamp = DateTime.now().millisecondsSinceEpoch * 1000;
    final random = Random().nextInt(1000);
    return '$random$timestamp';
  }
}

///
class DappConnectUserIdGenerator extends UserIdGenerator {
  ///
  @override
  Future<String> create(String appId, String publicKeyBase64String) async {
    final pre = "$appId@$publicKeyBase64String";
    final algorithm = Sha1();
    final bytes = utf8.encode(pre);
    final hash = await algorithm.hash(bytes);
    final hexString = hex.encode(hash.bytes);
    return 'bridge:$hexString';
  }
}
