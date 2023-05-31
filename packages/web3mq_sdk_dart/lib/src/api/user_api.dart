import 'dart:async';

import 'package:web3mq/src/api/responses.dart';

import '../error/error.dart';
import '../http/http_client.dart';
import '../utils/signer.dart';

///
enum SetPasswordType {
  /// register
  register,

  /// Reset password
  reset;

  /// The api path.
  String get path {
    switch (this) {
      case SetPasswordType.register:
        return "/api/user_register_v2/";
      case SetPasswordType.reset:
        return '/api/user_reset_password_v2/';
    }
  }

  ///
  String get purpase {
    switch (this) {
      case SetPasswordType.register:
        return "register";
      case SetPasswordType.reset:
        return 'reset password';
    }
  }
}

///
class UserApi {
  UserApi(this._client, this._signer);

  final Web3MQHttpClient _client;

  final Signer _signer;

  ///
  Future<UserRegisterResponse> register(
      String didType,
      String didValue,
      String userId,
      String pubKey,
      String pubKeyType,
      String signatureRaw,
      String signature,
      DateTime timestamp,
      String accessKey,
      {SetPasswordType type = SetPasswordType.register}) async {
    final response = await _client.post(
      type.path,
      data: {
        'userid': userId,
        "did_type": didType,
        "did_value": didValue,
        "did_signature": signature,
        "pubkey_value": pubKey,
        "pubkey_type": pubKeyType,
        "timestamp": timestamp.millisecondsSinceEpoch,
        "signature_content": signatureRaw,
        "testnet_access_key": accessKey
      },
    );
    final res = Web3MQResponse<UserRegisterResponse>.fromJson(
        response.data, (json) => UserRegisterResponse.fromJson(json));
    final data = res.data;
    if (res.code == 0 && null != data) {
      return data;
    }
    throw Web3MQNetworkError.raw(code: res.code, message: res.message ?? "");
  }

  Future<UserLoginResponse> login(
      String userId,
      String didType,
      String didValue,
      String signature,
      String signatureRaw,
      String mainPublicKey,
      String publicKey,
      String publicKeyType,
      int timestamp,
      int publicKeyExpiredTimestamp) async {
    final response = await _client.post("/api/user_login_v2/", data: {
      "userid": userId,
      "did_type": didType,
      "did_value": didValue,
      "login_signature": signature,
      "signature_content": signatureRaw,
      "main_pubkey": mainPublicKey,
      "pubkey_value": publicKey,
      "pubkey_type": publicKeyType,
      "timestamp": timestamp,
      "pubkey_expired_timestamp": publicKeyExpiredTimestamp
    });

    final res = Web3MQResponse<UserLoginResponse>.fromJson(
        response.data, (json) => UserLoginResponse.fromJson(json));
    final data = res.data;
    if (res.code == 0 && null != data) {
      return data;
    }
    throw Web3MQNetworkError.raw(code: res.code, message: res.message ?? "");
  }

  Future<UserLoginResponse> resetpassword(
      String didType,
      String didValue,
      String userId,
      String pubKey,
      String pubKeyType,
      String signatureRaw,
      String signature,
      DateTime timestamp,
      String accessKey) async {
    final response = await _client.post("/api/user_reset_password_v2/", data: {
      "userid": userId,
      "did_type": didType,
      "did_value": didValue,
      "did_signature": signature,
      "signature_content": signatureRaw,
      "pubkey_value": pubKey,
      "pubkey_type": pubKeyType,
      "timestamp": timestamp,
      "testnet_access_key": accessKey,
    });
    final res = Web3MQResponse<UserLoginResponse>.fromJson(
        response.data, (json) => UserLoginResponse.fromJson(json));
    final data = res.data;
    if (res.code == 0 && null != data) {
      return data;
    }
    throw Web3MQNetworkError.raw(code: res.code, message: res.message ?? "");
  }

  Future<UserInfo?> userInfo(String didType, String didValue) async {
    final response = await _client.post("/api/get_user_info/", data: {
      "did_type": didType,
      "did_value": didValue,
      "timestamp": DateTime.now().millisecondsSinceEpoch
    });
    final res = Web3MQResponse<UserInfo>.fromJson(
        response.data, (json) => UserInfo.fromJson(json));
    final data = res.data;
    if (res.code == 0) {
      return data;
    }
    throw Web3MQNetworkError.raw(code: res.code, message: res.message ?? "");
  }

  /// Updates user profile
  Future<void> updateProfile(String avatarUrl) async {
    final signResult = await _signer.signatureForRequest(null);
    final response = await _client.post(
      '/api/my_profile/',
      data: {
        'avatar_url': avatarUrl,
        "web3mq_signature": signResult.signature,
        "userid": signResult.userId,
        "timestamp": signResult.time.millisecondsSinceEpoch
      },
    );
    final res = CommonResponse.fromJson(response.data);
    if (res.code == 0) {
      return;
    }
    throw Web3MQNetworkError.raw(code: res.code, message: res.message ?? "");
  }
}
