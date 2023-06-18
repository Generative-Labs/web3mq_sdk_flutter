import 'dart:typed_data';

///
abstract class RequestSigner {
  ///
  Future<RequestSignedResult> sign(String? parameter);
}

///
abstract class RequestSignedResult {
  ///
  String get signature;

  ///
  String get userId;

  ///
  DateTime get time;
}
