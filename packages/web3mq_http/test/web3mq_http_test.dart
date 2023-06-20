import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:web3mq_http/src/model/pagination.dart';
import 'package:web3mq_http/src/service/api.dart';
import 'package:web3mq_http/src/service/request_signer.dart';
import 'package:web3mq_http/src/service/requests.dart';

import 'mocks.dart';

void main() {
  Response successResponse(String path, {Object? data}) => Response(
        data: data,
        requestOptions: RequestOptions(path: path),
        statusCode: 200,
      );

  late final client = MockHttpClient();
  late UserApi userApi;
  late NotificationApi notificationApi;
  late TopicApi topicApi;
  late RequestSigner signer;

  setUp(() {
    signer = MockSigner();
    userApi = UserApi(client, signer);
    notificationApi = NotificationApi(client, signer);
    topicApi = TopicApi(client, signer);
  });

  group("user api", () {
    test('register should work', () async {
      const userId = "userId";
      const didType = "didType";
      const didValue = "didValue";

      const path = '/api/user_register_v2/';
      when(() => client.post(path, data: any(named: 'data')))
          .thenAnswer((_) async => successResponse(path, data: {
                "code": 0,
                "message": "success",
                "data": {
                  "userid": userId,
                  "did_type": didType,
                  "did_value": didValue
                }
              }));
      final res = await userApi.register(
          "didType",
          "didValue",
          "userId",
          "pubKey",
          "pubKeyType",
          "signatureRaw",
          "signature",
          DateTime.now(),
          "accessKey");
      expect(res, isNotNull);
      verify(() => client.post(path, data: any(named: 'data'))).called(1);
      verifyNoMoreInteractions(client);
    });

    test('login should work', () async {
      const userId = "userId";
      const didType = "didType";
      const didValue = "didValue";

      const path = '/api/user_login_v2/';
      when(() => client.post(path, data: any(named: 'data')))
          .thenAnswer((_) async => successResponse(path, data: {
                "code": 0,
                "data": {
                  "userid": userId,
                  "did_type": didType,
                  "did_value": didValue
                }
              }));
      final res = await userApi.login(
          "userId",
          "didType",
          "didValue",
          "signature",
          "signatureRaw",
          "mainPublicKey",
          "publicKey",
          "publicKeyType",
          DateTime.now().millisecondsSinceEpoch,
          Duration(days: 7).inMilliseconds);
      expect(res, isNotNull);
      verify(() => client.post(path, data: any(named: 'data'))).called(1);
      verifyNoMoreInteractions(client);
    });

    test('userinfo should work', () async {
      const userId = "userId";
      const didType = "didType";
      const didValue = "didValue";

      const path = '/api/get_user_info/';
      when(() => client.post(path, data: any(named: 'data')))
          .thenAnswer((_) async => successResponse(path, data: {
                "code": 0,
                "data": {
                  "userid": userId,
                  "did_type": didType,
                  "did_value": didValue
                }
              }));
      final res = await userApi.userInfo("didType", "didValue");
      expect(res, isNotNull);
      verify(() => client.post(path, data: any(named: 'data'))).called(1);
      verifyNoMoreInteractions(client);
    });
  });

  group("notification api", () {
    test('query should work', () async {
      const path = '/api/notification/history/';

      when(() =>
              client.get(path, queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => successResponse(path, data: {
                "code": 0,
                "data": {"total": 1, "result": []}
              }));
      final res = await notificationApi.query(
          NotificationType.all, Pagination(page: 1, size: 100));

      expect(res, isNotNull);
      verify(() =>
              client.get(path, queryParameters: any(named: 'queryParameters')))
          .called(1);
      verifyNoMoreInteractions(client);
    });

    test('mark read should work', () async {
      const path = '/api/notification/status/';

      when(() => client.post(path, data: any(named: 'data')))
          .thenAnswer((_) async => successResponse(path, data: {"code": 0}));
      final res = await notificationApi
          .updateReadStatus(["notification_0"], ReadStatus.read);

      expect(res, isNotNull);
      verify(() => client.post(path, data: any(named: 'data'))).called(1);
      verifyNoMoreInteractions(client);
    });

    test('subscribe topic should work', () async {
      const path = '/api/subscribe_topic/';

      when(() => client.post(path, data: any(named: 'data')))
          .thenAnswer((_) async => successResponse(path, data: {"code": 0}));
      final res = await topicApi.subscribeTopic("a_topic");

      expect(res, isNotNull);
      verify(() => client.post(path, data: any(named: 'data'))).called(1);
      verifyNoMoreInteractions(client);
    });

    test('getting my subscribe topic should work', () async {
      const path = '/api/my_create_topic_list/';

      when(() =>
              client.get(path, queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => successResponse(path, data: {
                "code": 0,
                "data": {"total": 0}
              }));
      final res =
          await topicApi.mySubscribeTopics(Pagination(page: 1, size: 100));

      expect(res, isNotNull);
      verify(() =>
              client.get(path, queryParameters: any(named: 'queryParameters')))
          .called(1);
      verifyNoMoreInteractions(client);
    });
  });
}
