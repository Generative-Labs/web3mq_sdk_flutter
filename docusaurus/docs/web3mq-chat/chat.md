---
sidebar_position: 1
---
# Chat

## Channel List

### Listening to the Channel List

You can keep track of the list of channels by listening to the **`channelsStream`** event:

```dart
client.state.channelsStream.listen((event) {
  // handle the channel list 
});
```

### Querying Offline Channels

To query channels from `persistenceClient`, use the **`queryChannelsOffline`** method:

```dart
final page = await client.queryChannelsOffline(pagination);
```

### Querying Online Channels

To query channels from remote server, use the **`queryChannelsOnline`** method:

```dart
final page = await client.queryChannelsOnline(pagination);
```

### Listening to Channel Queries

The **`queryChannels`** method returns a stream of channel models, which can be paginated using the **`Pagination`** object. If the channels have already been queried, the method returns them from a cache. Otherwise, it first queries the offline channels and yields them if they are not empty. It then starts an online query and yields the channels from that query once it completes. If the online query fails and there are no local channels, the method throws an error.

```dart
client.queryChannels(pagination).listen( (event) {
  // handle the channels 
});
```

### Adding a Channel

To add a channel, use the **`addChannel`** method, providing the topic, topic type, channel ID, and channel type:

```dart
await client.addChannel(topic, topicType, channelId, channelType);
```

## Messages

### Sending message

To send a text message, call the **`sendText`** method with the message text and the ID of the topic.

```dart
client.sendText('hello, world!', topicId, needStore: false);
```

 If you want to send a message to a thread, then **`threadId`** is required. Otherwise, it can be left null.

```dart
client.sendText('hello, world!', topicId, threadId);
```

By default, the **`needStore`** parameter is set to **`true`**, which means that the message will be stored on the web3mq network and can be retrieved using the **`queryMessagesByTopic`** method. If you set **`needStore`** to **`false`**, the message will not be stored on the network.

Note: that setting **`needStore`** to **`true`** may incur additional fees for the message sender. For more information, please consult with the sales team.

### Message sending status

To receive updates on the message sending status, listen to the **`messageUpdated`** event:

```dart
client.on(EventType.messageUpdated).listen((event) {
  // handle the message status update 
  final status = event.messageStatusResponse;
};
```

### Receiving new messages

To receive new messages, listen to the **`newMessageStream`** event:

```dart
client.newMessageStream.listen((message) {
  // handle the message.   
};
```

### Query the message list

To query the message list from remote server, call the **`queryMessagesByTopic`** method with the ID of the topic and a pagination object:

```dart
final messageList = await client.queryMessagesByTopic(topicId, pagination);
```

**Note:** **`queryLocalMessagesByTopic`** method retrieves the cached messages from the **`persistenceClient`**.

```dart
final messageList = await client.queryLocalMessagesByTopic(topicId)
```

## Thread

### Create Thread

To create a thread, call the **`createThreadByMessage`** method with the ID of the original message, the ID of the topic, and the name of the thread:

```dart
client.createThreadByMessage(messageId, 'topicId', 'threadName');
```

### Thread List

To query the list of threads by given topic.

```dart
final list = await client.threadListByTopic('topicId');
```
