import 'package:mocktail/mocktail.dart';
import 'package:web3mq_http/web3mq_http.dart';

class MockRequestSignedResult extends RequestSignedResult {
  @override
  String get signature => 'signature';

  @override
  DateTime get time => DateTime.now();

  @override
  String get userId => 'userId';
}

class MockSigner extends Mock implements RequestSigner {
  @override
  Future<RequestSignedResult> sign(String? parameter) {
    return Future(() => MockRequestSignedResult());
  }
}

class MockHttpClient extends Mock implements Web3MQHttpClient {}
