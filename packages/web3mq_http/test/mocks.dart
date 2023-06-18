import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:fixnum/fixnum.dart';
import 'package:logging/logging.dart';
import 'package:mocktail/mocktail.dart';
import 'package:web3mq_http/src/service/request_signer.dart';

class MockSigner extends Mock implements RequestSigner {
  @override
  Future<String> sign(String raw, Uint8List privateKey) {
    return Future(() => "test-signature");
  }
}
