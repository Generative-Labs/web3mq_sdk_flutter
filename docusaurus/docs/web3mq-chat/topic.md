---
sidebar_position: 5
---

# Topic

## Subscribe

Use the `subscribeTopic` method to subscribe to a topic by providing the `topicId`, and start receiving notifications from that topic.

```dart
await client.subscribeTopic(topicId);
```

## Create a Topic

Use the `createTopic` method to create a new topic with the given `topicName`.

```dart
final topic = await client.createTopic(topicName);
```

## Publish a Message

Use the `publish` method to publish a new message to the topic identified by `topicId`. The topic must be created by the user themselves.

```dart
await client.publish(title, content, topicId);
```

## Get Subscribed Topics

Use the `mySubscribeTopics` method to get a list of topics that the current user is subscribed to, with pagination support.

```dart
final topics = await client.mySubscribeTopics(pagination);

```
