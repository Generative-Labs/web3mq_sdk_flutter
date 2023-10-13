# Quick Start

## What we can learn from this tutorial

- how to integrate the Web3MQ Flutter SDK into your own projects
- how to initialize the Web3MQ client and configure it
- how to join & create a group
- how to send & receive messages specifically in a group

## REQUIREMENTS

- Dart SDK: “>=2.19.4 <4.0.0”
- Flutter SDK: “>=3.7.0”
- A Web3MQ API Key

Before all, you should have Flutter development environment, see more details on: [https://docs.flutter.dev/get-started/install](https://docs.flutter.dev/get-started/install)

While we are committed to building an open and collectively owned public good, our early stage testnet requires an API key in order to connect. This is to control capacity to make sure that each early partner and developer is able to build a great experience on top of Web3MQ. [Apply here](https://web3mq.com/apply).

## Add dependency

Add this to your package’s `pubspec.yaml` file, use the `latestversion`

```yaml
dependencies: 
  web3mq: 0.2.0-dev.1
```

You should then run `flutter packages get`

## Example Project

There is a detailed Flutter example project in the `example` folder. You can directly run and play on it.

## Setup API Client

First you need to instantiate a chat client. The chat client will manage API call, event handling and manage the web socket connection to Web3mq servers. You should only create the client once and re-use it across your application. The simplest way to initialize the client is to pass your API key to the constructor. The API key should be applied from our team.

```dart
final client = Web3MQClient("api-key");
```

### Endpoint

You can customize the `baseURL`, which is set to `TestnetEndpoint.sg1` by default, or use `UtilsApi().findTheLowestLatencyEndpoint()` to get the endpoint with the lowest latency and assign it to `baseURL`.

```dart
final endpoint = await UtilsApi().findTheLowestLatencyDevEndpoint();
final client = Web3MQClient("api-key", baseURL: endpoint);
```

During this initial testing phase, we’ve hosted complete networks of Web3MQ nodes in different regions around the globe. Connect to these endpoints below, to access the Web3MQ Testnet.

- [https://testnet-us-west-1-1.web3mq.com](https://testnet-us-west-1-1.web3mq.com/)
- [https://testnet-us-west-1-2.web3mq.com](https://testnet-us-west-1-2.web3mq.com/)
- [https://testnet-ap-jp-1.web3mq.com](https://testnet-ap-jp-1.web3mq.com/)
- [https://testnet-ap-jp-2.web3mq.com](https://testnet-ap-jp-2.web3mq.com/)
- [https://testnet-ap-singapore-1.web3mq.com](https://testnet-ap-singapore-1.web3mq.com/)
- [https://testnet-ap-singapore-2.web3mq.com](https://testnet-ap-singapore-2.web3mq.com/)

### Wallet Connector

Some methods that SDK provides require wallet signature, you should setup the `WalletConnector` before calling those methods.

```dart
client.walletConnector = yourWalletConnector;
```

Each project may have a different way to connect to a wallet. We provide a unified interface as the entry point for connecting and signing wallets. When the SDK needs wallet information or signatures, it will call the corresponding methods in `WalletConnector`. Because wallet communication supports the unified CAIP standard, whether through WalletConnectV2 or other wallet communication SDKs, it can be easily adapted to the `WalletConnector`interface.

```dart
abstract class WalletConnector {
  /// Gets the signature of `personal_sign`.
  Future<String> personalSign(String message, String address,
      {String? password});

  /// Connects wallet, and gets the user wallet info.
  Future<Wallet> connectWallet();
}
```

here’s a example code for implementing a WalletConnectV2 connector:

[WalletConnectV2 Connector](https://s3labs.notion.site/WalletConnectV2-Connector-dc8df43cb47a4ea28b0dd3c4cb020642?pvs=25)

### Offline storage

To add data persistence you can extend the class `PersistenceClient` and pass an instance to the `ChatClient`. `Web3MQPersistenceClient` is a default implementation.

```dart
client.persistenceClient = Web3MQPersistenceClient();
```

## Create credentials

For any first-time user of Web3MQ’s network, you’ll need to create credentials on Web3MQ’s network.

This method needs wallet signature, make sure you have setup `WalletConnector` already. `credentials` contains your `PrivateKey` and `UserId`.

`DIDs` have two parts: a type and a value. The type can be "eth" or "starknet", and the value is a wallet address.

```dart
// Keep your credentials in a safe place!
final credentials = await client.createCredentials(did, password);
```

## Connect

After you have created credentials, let’s continue to connect to Web3MQ’s network.

### Session key

The `SessionKey` is a temporary key that is used to connect to Web3MQ’s network.

To generate a session key with `DID` and `PrivateKey`:

```dart
final sessionKey = await client.generateSessionKey(credentials.did, credentials.privateKey, expiredDuration);
```

you could persist `SessionKey` for the connection next time.

### Connect with a `SessionKey`

Now you can connect to Web3MQ with the `SessionKey`.

```dart
await client.connectUser(sessionKey)
```

listen the `connectionStatusStream` to track connection status.

```dart
client.connectionStatusStream.listen((event) {
    // handle the event
});
```

## Chat

Let’s continue by sending your first message to another user and joining a chat group and  sending messages.

### Chat with another user

It's very easy to send a message to another user, you just need to know their UserId.

```dart
final message = await client.sendText('hello, world!', userId);

// If you'd like to track the messag status updting,
client.messageStatusUpdingStream.listen((res) {
  // handle the status updting response
  if (res.messageId == message.messageId) {
    
  }
});
```

### Create a chat group

 A group contains messages and a list of members who are permanently associated with the group. More docs about group see [Group](/docs/Web3MQ-SDK/Dart-SDK/Chat/group).

One way to join a group is to create your own group.

```dart
final group = await client.createGroup('Group Name', 'avatar url',
      permissions: GroupPermission.public);
```

Group chat permission currently only has group:join rule, which indicates the permission to join a group. group:join rule has GroupPermission.public and GroupPermission.invite values, and its value type is ‘enum’

- `GroupPermission.public`: Everyone can join without restrictions.
- `GroupPermission.invite`: Only the group owner can invite friends to join.

### Join a chat group

If you prefer to join a existing group, you can use the **`joinGroup`** method with the group id:

```dart
await client.joinGroup(groupId);
```

### Send a message to a group

Now we have a group, let’s send a message to the group:

```dart
final message = await client.sendText('hello, world!', group.groupId);
```

### Receive messages

To receive new messages from the group or single chat, listen to the **`newMessageStream`** event:

```dart
client.newMessageStream.listen((message) {
 // filter the messages you need to handle.
 
  if (message.topic == group.groupId) {
    // handle the message in the group
  }
 if (message.topic == userId) {
    // handle the message with the user
  }
})
```

### Query the message list

If you want to view the historical messages:

```dart
final pagination = TimePagination(limit: 20, timestampBefore: DateTime.now().millisecondsSinceEpoch);
// group messages 
final messages = await client.queryMessagesByGroupId(group.groupId, pagination)
// single chat messages 
final messages = await client.queryMessagesByUserId(userId, pagination)
```

## Code example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/wallet_connectv2_connector.dart';
import 'package:web3mq/web3mq.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());

  final walletConnector = WalletConnectV2Connector();
  final url = await UtilsApi().findTheLowestLatencyEndpoint();
  final client = Web3MQClient('apiKey', baseURL: url, wc: walletConnector);
 
 // This may throws an error when your device does not have a wallet that supports walletconnectV2.
  final wallet = await walletConnector.connectWallet();

  final did = wallet.dids.firstOrNull;
  if (did == null) {
    throw Exception('No did found');
  }
  final user = await client.userInfo(did.type, did.value);
  if (user == null) {
    // User not found, we need to create credentials firstly.
    final credentials = await client.createCredentials(did, 'your-password');
    final sessionKey = await client.generateSessionKey(
        did, credentials.userId, const Duration(days: 7));
    await client.connectUser(sessionKey);
  } else {
    // if there's no private key cache, we need to ask for the password
    // to retrieve the private key. Otherwise, we can just use the private key
    // to generate the session key.
    // `final sessionKey = await client.generateSessionKey(
    //   did, user.userId, const Duration(days: 7));`
    final sessionKey = await client.generateSessionKeyWithPassword(
        did, 'your-password', const Duration(days: 7));
    await client.connectUser(sessionKey);
  }

  final group = await client.createGroup('test-group-name', null);
  final message = await client.sendText('hello, chat', group.groupId);
  client.messageStatusUpdingStream.listen((event) {
    if (message.messageId == event.messageId &&
        event.messageStatus == 'received') {
      print('message sent successfully');
    }
  });
  client.newMessageStream.listen((message) {
    if (message.topic == group.groupId) {
      print('message received: ${message.text}');
    }
  });
}
```

## What’s next

For detailed API documentation, please refer to other sections. [Chat Client Docs](/docs/category/chat)
