import 'package:web3mq/src/api/requests.dart';
import 'package:web3mq/src/api/responses.dart';
import 'package:web3mq/src/error/error.dart';
import 'package:web3mq_http/src/service/request_signer.dart';

import '../http/http_client.dart';
import '../models/pagination.dart';
import '../utils/signer.dart';

///
class NotificationApi {
  /// Initialize a new user api
  NotificationApi(this._client, this._signer);

  final Web3MQHttpClient _client;

  final RequestSigner _signer;

  /// Requests notifications with a given query.
  Future<Page<NotificationQueryResponse>> queryAll(
      Pagination pagination) async {
    return await query(NotificationType.all, pagination);
  }

  /// Requests notifications with a given query.
  Future<Page<NotificationQueryResponse>> query(
      NotificationType type, Pagination pagination) async {
    final signResult = await _signer.sign(type.value);
    final response = await _client.get(
      '/api/notification/history/',
      queryParameters: {
        'notice_type': type.value,
        "page": pagination.page,
        "size": pagination.size,
        "web3mq_signature": signResult.signature,
        "userid": signResult.userId,
        "timestamp": signResult.time.millisecondsSinceEpoch
      },
    );
    final res = Web3MQListResponse<NotificationQueryResponse>.fromJson(
        response.data, (json) => NotificationQueryResponse.fromJson(json));
    if (res.code == 0) {
      return res.data;
    }
    throw Web3MQNetworkError.raw(code: res.code, message: res.message ?? "");
  }

  /// Mark notification as read.
  Future<CommonResponse> updateReadStatus(
      List<String> notificationIds, ReadStatus status) async {
    final statusString = status.name;
    final signResult = await _signer.sign(statusString);
    final response = await _client.post(
      '/api/notification/status/',
      data: {
        'messages': notificationIds,
        "status": statusString,
        "web3mq_signature": signResult.signature,
        "userid": signResult.userId,
        "timestamp": signResult.time.millisecondsSinceEpoch
      },
    );
    return CommonResponse.fromJson(response.data);
  }
}
