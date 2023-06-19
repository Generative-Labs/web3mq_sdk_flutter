import '../../web3mq_http.dart';
import '../model/error.dart';
import '../model/pagination.dart';
import 'request_signer.dart';
import 'responses.dart';

///
class TopicApi {
  /// Initialize a new topic api
  TopicApi(this._client, this._signer);

  final Web3MQHttpClient _client;

  final RequestSigner _signer;

  Future<Topic> createTopic(String topicName) async {
    final signResult = await _signer.sign(null);
    final response = await _client.post("/api/create_topic/", data: {
      "topic_name": topicName,
      "userid": signResult.userId,
      "web3mq_signature": signResult.signature,
      "timestamp": signResult.time.millisecondsSinceEpoch
    });

    final res = Web3MQResponse<Topic>.fromJson(
        response.data, (json) => Topic.fromJson(json));
    final data = res.data;
    if (res.code == 0 && null != data) {
      return data;
    }
    throw Web3MQNetworkError.raw(code: res.code, message: res.message ?? "");
  }

  /// Subscribe a topic, then you can receive notifications from that topic.
  Future<CommonResponse> subscribeTopic(String topicId) async {
    final signResult = await _signer.sign(topicId);
    final response = await _client.post(
      '/api/subscribe_topic/',
      data: {
        'topicid': topicId,
        "web3mq_signature": signResult.signature,
        "userid": signResult.userId,
        "timestamp": signResult.time.millisecondsSinceEpoch
      },
    );
    return CommonResponse.fromJson(response.data);
  }

  /// Publish message to topic.
  Future<CommonResponse> publish(
      String title, String content, String topicId) async {
    final signResult = await _signer.sign(topicId);
    final response = await _client.post(
      '/api/publish_topic_message/',
      data: {
        'topicid': topicId,
        'title': title,
        'content': content,
        "web3mq_signature": signResult.signature,
        "userid": signResult.userId,
        "timestamp": signResult.time.millisecondsSinceEpoch
      },
    );
    return CommonResponse.fromJson(response.data);
  }

  /// Subscribed topics.
  Future<List<Topic>> mySubscribeTopics(Pagination pagination) async {
    final signResult = await _signer.sign(null);
    final response = await _client.get(
      '/api/my_create_topic_list/',
      queryParameters: {
        'page': pagination.page,
        "size": pagination.size,
        "web3mq_signature": signResult.signature,
        "userid": signResult.userId,
        "timestamp": signResult.time.millisecondsSinceEpoch
      },
    );
    final res = MySubscribeTopicsResponse.fromJson(response.data);
    if (res.code == 0) {
      return res.data;
    }
    throw Web3MQNetworkError.raw(code: res.code, message: res.message ?? "");
  }
}
