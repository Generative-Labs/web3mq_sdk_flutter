part of 'client.dart';

extension TopicExtension on Web3MQClient {
  /// Subscribe a topic by topicId, then you can receive notifications from that topic.
  Future<void> subscribeTopic(String topicId) =>
      _service.topic.subscribeTopic(topicId);

  /// Creates a topic.
  Future<Topic> createTopic(String topicName) =>
      _service.topic.createTopic(topicName);

  /// Publishes a message to topic. The topic must be created by yourself.
  Future<void> publish(String title, String content, String topicId) =>
      _service.topic.publish(title, content, topicId);

  /// Gets topics you're subscribing.
  Future<List<Topic>> mySubscribeTopics(Pagination pagination) =>
      _service.topic.mySubscribeTopics(pagination);
}
