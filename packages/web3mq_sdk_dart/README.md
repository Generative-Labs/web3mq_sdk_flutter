
# Quick Start

## REQUIREMENTS

- Dart SDK:  “>=2.18.5 <4.0.0”
- A Web3MQ API Key

## Add dependency

Add this to your package's `pubspec.yaml` file, use the `latestversion`

```yaml
dependencies:
  web3mq: 0.1.0
```

You should then run `flutter packages get`

## Example Project

There is a detailed Flutter example project in the `example` folder. You can directly run and play on it.

## Setup API Client

First you need to instantiate a chat client. The chat client will manage API call, event handling and manage the web socket connection to Web3mq servers. You should only create the client once and re-use it across your application.

```dart
final client = Web3MQClient("api-key");
```

### Logging

By default, the chat client will write all messages with level Warn or Error to stdout.

### Change Logging Level

During development, you might want to enable more logging information, you can change the default log level when constructing the client.

```dart
final client = Web3MQClient("api-key", logLevel: Level.INFO);
```

### Custom Logger

You can handle the log messages directly instead of have them written to `stdout`, this is very convenient if you use an error tracking tool or if you want to centralize your logs into one facility.

```dart
myLogHandlerFunction = (LogRecord record) {
// do something with the record (ie. send it to Sentry or Fabric)
}

final client = Web3MQClient("api-key", logHandlerFunction: myLogHandlerFunction);
```

### Wallet Connector

Some methods that SDK provides require wallet signature,  you should setup the `WalletConnector` before calling those methods.

```dart
client.walletConnector = walletConnector;
```

```dart
abstract class WalletConnector {
  /// Gets the signature of `personal_sign`.
  Future<String> personalSign(String message, String address,
      {String? password});

  /// Connects wallet, and gets the user wallet info.
  Future<Wallet> connectWallet();
}

abstract class Wallet {
  /// account_id support CAIP-10
  final List<String> accounts;
 
 Wallet(this.accounts);
}
```

### Offline storage

To add data persistence you can extend the class `PersistenceClient` and pass an instance to the `ChatClient`. `Web3MQPersistenceClient` is a default implementation.

```dart
client.persistenceClient = Web3MQPersistenceClient();
```

## Register

For any first-time user of Web3MQ's network, you'll need to register on Web3MQ's network.

This method needs wallet signature, make sure you have setup `WalletConnector` already. `RegisterResponse` contains your `PrivateKey` and `UserId`.

```dart
// Keep your private key in a safe place!
final registerResponse = await client.register(did, password);
```

### Retrieve Private Key

Whenever you want, you can retrieve your own `PrivateKey` through this method.

```dart
// Keep your private key in a safe place!
final privateKeyHex = await client.retrievePrivateKey(did, password);
```

## Connect

### Get a `User`

Get a user with DID and password, also with an duration for expired.

```dart
final user = await client.user(did, password, expiredDuration);
```

Or if you has the `PrivateKey` .

```dart
final user = await client.user(did, privateKeyHex, expiredDuration)
```

you could persist `user` for the connection next time.

### Connect with a `User`

Now you can connect to `Web3MQ` with the `User` which you may want to persist.

```dart
await client.connectUser(user)
```

listen the `wsConnectionStatusStream` to track connection status:

```dart
client.wsConnectionStatusStream.listen((event) { 
    // handle the event 
});
```

## Notifications

### Subscribe

Subscribe a topic with `topicId`, then you can receive notifications from that `topic`.

```dart
client.subscribeTopic(topicId);
```

### Receive

You can use the following method to subscribe notifications from the web3mq server.

```dart
client.notificationStream.listen( (notifications) {
  // handle the notifications.
});
```

### Read Status

You may need other side to know if you have read the notification.

```dart
client.markNotificationsRead(notificationsIds);
```

### Query

You can query all historical notifications by types and pagination.

```dart
Page<Notification> res = await client.queryNotifications(type, pagination);
```

## Chat

### Channel List

To keep track of the list of channels, listen to the **`channelsStream`** event:

```dart
client.state.channelsStream.listen((event) {
  // handle the channel list 
});
```

### Sending message

To send a text message, call the **`sendText`** method with the message text and the ID of the topic:

```dart
client.sendText('hello, world!', topicId)
```

### Message sending status

To receive updates on the message sending status, listen to the **`messageUpdated`** event:

```dart
client.on(EventType.messageUpdated).listen((event) {
  // handle the message status update 
  final status = event.messageStatusResponse;
}
```

### Receiving new messages

To receive new messages, listen to the **`newMessageStream`** event:

```dart
client.newMessageStream.listen((message) {
  // handle the message.   
}
```

### Query the message list

To query the message list, call the **`queryMessagesByTopic`** method with the ID of the topic and a pagination object:

```dart
client.queryMessagesByTopic('topicId', pagination)
```

### Create Thread

To create a thread, call the **`createThreadByMessage`** method with the ID of the original message, the ID of the topic, and the name of the thread:

```dart
client.createThreadByMessage(messageId, 'topicId', 'threadName')
```

### Thread List

To query the list of threads by given topic.

```dart
final list = await client.threadListByTopic('topicId')
```
