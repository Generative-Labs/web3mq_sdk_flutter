
# Quick Start

## What we can learn from this tutorial

- how to integrate the Web3MQ Flutter SDK into your own projects
- how to initialize the Web3MQ client and configure it
- how to join & create a group
- how to send & receive messages specifically in a group

## REQUIREMENTS

- Dart SDK:  “>=2.18.5 <4.0.0”
- A Web3MQ API Key

:::note

While we are committed to building an open and collectively owned public good, our early stage testnet requires an API
key in order to connect. This is to control capacity to make sure that each early partner and developer is able to build
a great experience on top of Web3MQ. [Apply here](https://web3mq.com/apply).

:::

## Add dependency

Add this to your package's `pubspec.yaml` file, use the `latestversion`

```yaml
dependencies:
  web3mq: 0.1.3-dev.3
```

You should then run `flutter packages get`

## Example Project

You can find a complete example project here:
<https://github.com/Generative-Labs/web3mq_sdk_flutter/tree/main/packages/web3mq_sdk_flutter_demo>

## Setup API Client

First you need to instantiate a chat client. The chat client will manage API call, event handling and manage the web socket connection to Web3mq servers. You should only create the client once and re-use it across your application. The simplest way to initialize the client is to pass your API key to the constructor. The API key should be applied from our team.

```dart
final client = Web3MQClient("api-key");
```

### Endpoint

You can customize the `baseURL`, which is set to `TestnetEndpoint.sg1` by default, or use `UtilsApi.findTheLowestLatencyEndpoint()` to get the endpoint with the lowest latency and assign it to `baseURL`.

```dart
final endpoint = await UtilsApi.findTheLowestLatencyDevEndpoint();
final client = Web3MQClient("api-key", baseURL: endpoint);
```

During this initial testing phase, we've hosted complete networks of Web3MQ nodes in different regions around the globe.
Connect to these endpoints below, to access the Web3MQ Testnet.

- <https://testnet-us-west-1-1.web3mq.com>
- <https://testnet-us-west-1-2.web3mq.com>
- <https://testnet-ap-jp-1.web3mq.com>
- <https://testnet-ap-jp-2.web3mq.com>
- <https://testnet-ap-singapore-1.web3mq.com>
- <https://testnet-ap-singapore-2.web3mq.com>

### Logging

By default, the chat client will write all messages with level Warn or Error to stdout.

#### Change Logging Level

During development, you might want to enable more logging information, you can change the default log level when constructing the client.

```dart
final client = Web3MQClient("api-key", logLevel: Level.INFO);
```

#### Custom Logger

You can handle the log messages directly instead of have them written to `stdout`, this is very convenient if you use an error tracking tool or if you want to centralize your logs into one facility.

```dart
myLogHandlerFunction = (LogRecord record) {
// do something with the record.
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

After you have registered, let's continue to connect to Web3MQ's network.

### Session key

The SessionKey is a temporary key that is used to connect to Web3MQ's network.

To generate a session key with `DID` and `Password`:

```dart
final sessionKey = await client.userWithDIDAndPassword(did, password, expiredDuration);
```

or with `DID` and `PrivateKey`:

```dart
final sessionKey = await client.userWithDIDAndPrivateKey(did, privateKeyHex, expiredDuration)
```

you could persist `SessionKey` for the connection next time.

### Connect with a `SessionKey`

Now you can connect to Web3MQ with the `SessionKey`.

```dart
await client.connectUser(sessionKey)
```

listen the `wsConnectionStatusStream` to track connection status.

```dart
client.wsConnectionStatusStream.listen((event) { 
    // handle the event 
});
```

## Chat

Let’s continue by joining a chat group and sending your first message. A group contains messages and a list of members who are permanently associated with the group. More docs about group see [Group](/docs/Web3MQ-SDK/Dart-SDK/Chat/group.md).

### Create a chat group

One way to join a group is to create your own group.

```dart
final group = await client.createGroup('Group Name', 'avatar url',
      permissions: GroupPermission.public);
```

:::note

Group chat permission currently only has group:join rule, which indicates the permission to join a group. group:join rule has GroupPermission.public and GroupPermission.invite values, and its value type is 'enum'

- 1.`GroupPermission.invite`: Only the group owner can invite friends to join.
- 2.`GroupPermission.public`: Everyone can join without restrictions.

:::

### Join a chat group

If you prefer to join a existing group, you can use the **`joinGroup`** method with the group id:

```dart
await client.joinGroup(groupId);
```

### Send a message to a group

Now we have a group, let's send a message to the group:

```dart
final message = await client.sendText('hello, world!', group.groupId);
```

### Receive messages

To receive new messages from the group, listen to the **`newMessageStream`** event:

```dart
client.newMessageStream.listen((message) {
  if (message.topic == group.groupId) {
    // handle the message in the group
  }
}
```

### Query the message list

If you want to view the historical messages:

```dart
final pagination = TimePagination(limit: 20, timestampBefore: DateTime.now().millisecondsSinceEpoch);
final messages = await client.queryMessagesByTopic(group.groupId, pagination)
```
