import 'package:web3mq/src/api/responses.dart';
import 'package:web3mq/src/models/pagination.dart';
import 'package:web3mq_http/src/service/request_signer.dart';

import '../error/error.dart';
import '../http/http_client.dart';
import '../utils/signer.dart';

enum FollowAction {
  follow,
  unfollow;
}

class ContactsApi {
  /// Initialize a new contacts api
  ContactsApi(this._client, this._signer);

  final Web3MQHttpClient _client;

  final RequestSigner _signer;

  Future<Page<FollowUser>> followings(Pagination pagination) async {
    final signResult = await _signer.sign(null);
    final response = await _client.get(
      '/api/user_following/',
      queryParameters: {
        "page": pagination.page,
        "size": pagination.size,
        "web3mq_user_signature": signResult.signature,
        "userid": signResult.userId,
        "timestamp": signResult.time.millisecondsSinceEpoch
      },
    );
    final res = Web3MQListResponse<FollowUser>.fromJson(
        response.data, (json) => FollowUser.fromJson(json));
    if (res.code == 0) {
      return res.data;
    }
    throw Web3MQNetworkError.raw(code: res.code, message: res.message ?? "");
  }

  Future<Page<FollowUser>> followers(Pagination pagination) async {
    final signResult = await _signer.sign(null);
    final response = await _client.get(
      '/api/user_followers/',
      queryParameters: {
        "page": pagination.page,
        "size": pagination.size,
        "web3mq_user_signature": signResult.signature,
        "userid": signResult.userId,
        "timestamp": signResult.time.millisecondsSinceEpoch
      },
    );
    final res = Web3MQListResponse<FollowUser>.fromJson(
        response.data, (json) => FollowUser.fromJson(json));
    if (res.code == 0) {
      return res.data;
    }
    throw Web3MQNetworkError.raw(code: res.code, message: res.message ?? "");
  }

  /// Follows user
  Future<void> follow(
    String targetUserId,
    String didType,
    String? didPublicKey,
    String? message,
    String signContent,
    String signature,
  ) async =>
      _follow(FollowAction.follow, targetUserId, didType, didPublicKey, message,
          signContent, signature);

  /// Unfollows user
  Future<void> unfollow(
    String targetUserId,
    String didType,
    String? didPublicKey,
    String signContent,
    String signature,
  ) async =>
      _follow(FollowAction.unfollow, targetUserId, didType, didPublicKey, null,
          signContent, signature);

  Future<void> _follow(
    FollowAction action,
    String targetUserId,
    String didType,
    String? didPublicKey,
    String? message,
    String signContent,
    String signature,
  ) async {
    final signResult = await _signer.sign(null);
    final response = await _client.post(
      '/api/following/',
      data: {
        'action': action.name,
        'target_userid': targetUserId,
        "did_type": didType,
        'sign_content': signContent,
        'did_pubkey': didPublicKey,
        'content': message,
        "did_signature": signature,
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
