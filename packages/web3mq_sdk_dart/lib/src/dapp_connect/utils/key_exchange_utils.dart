import 'dart:typed_data';

import 'package:pointycastle/digests/sha512.dart';
import 'package:web3mq/src/dapp_connect/utils/ed25519.dart';

///
class KeyExchagneUtils {
  static Uint8List skToCurve25519(Uint8List ed25519Sk) {
    final sha512 = SHA512Digest();
    final h = Uint8List(64);
    sha512.update(ed25519Sk, 0, ed25519Sk.length);
    sha512.doFinal(h, 0);
    // curve25519 clamping
    h[0] &= 248;
    h[31] &= 127;
    h[31] |= 64;
    return h.sublist(0, 32);
  }

  static Uint8List pkToCurve25519(Uint8List ed25519Pk) {
    return Uint8List.fromList(cryptoSignEd25519PkToCurve25519(ed25519Pk));
  }
}

List<int> cryptoSignEd25519PkToCurve25519(List<int> ed25519Pk) {
  final A = GE25519P3();
  final x = FieldElement();
  final oneMinusY = FieldElement();

  GeFromBytesNegateVartime(A, Uint8List.fromList(ed25519Pk));

  FeOne(oneMinusY);
  FeSub(oneMinusY, oneMinusY, A.Y);
  FeOne(x);
  FeAdd(x, x, A.Y);
  FeInvert(oneMinusY, oneMinusY);
  FeMul(x, x, oneMinusY);

  var curve25519Bytes = Uint8List.fromList(ed25519Pk.map((e) => 0).toList());
  FeToBytes(curve25519Bytes, x);
  return curve25519Bytes;
}
