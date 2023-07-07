---
sidebar_position: 1
---

# web3mq_websocket

A lightware websocket tool to communicate with web3mq.

## Installation

To use [**web3mq_websocket**](https://pub.dev/packages/web3mq_websocket), add it to your pubspec.yaml file:

```yaml
dependencies:
  web3mq_websocket: ^0.1.0-dev.1
```

## Features

- Lightware websocket manager to communicate with **web3mq**.
- Reconnect automumaccly.
- Fully Customisable support.

## Simple Usage

```dart

  // Initial 
  final websocket = Web3MQWebSocketManager(baseUrl: 'endpoint');

  // Connect 
  await websocket.connect(user);

  // Sending message.
  websocket.sendText('text', 'topic');

  // Receiving message.
  websocket.messageStream.listen((message) {});

  // Receiving notification.
  websocket.notificationStream.listen((notification) {});

```

## Endpoint

The simplest way to initial the websocket manager is to provide the `baseUrl` of the web3mq endpoint.

```dart
final websocket = Web3MQWebSocketManager(baseUrl: 'endpoint');
```

Here's a set of web3mq endpoint:

- <https://testnet-ap-jp-1.web3mq.com>
- <https://testnet-ap-jp-2.web3mq.com>
- <https://testnet-ap-singapore-1.web3mq.com>
- <https://testnet-ap-singapore-2.web3mq.com>
- <https://testnet-us-west-1-1.web3mq.com>
- <https://testnet-us-west-1-2.web3mq.com>

- <https://dev-ap-jp-1.web3mq.com>
- <https://dev-ap-singapore-1.web3mq.com>
- <https://dev-us-west-2.web3mq.com>

## User

To use [**web3mq_websocket**](https://pub.dev/packages/web3mq_websocket), you need a web3mq user. User is the credential for the connection.

User has three properties and can be obtained from the registration and login API.

```dart
class User {
  /// The user ID.
  final String userId;

  /// Contains `did_type` and `did_value`. For example, `DID('eth', '0x1234567890abcdef')`.
  final DID did;

  /// The user's private key.
  final Uint8List privateKey;
}
```

## Reconnection

`Web3MQWebSocketManager` automatically reconnects when the connection is lost. You can also set the `reconnectionMonitorInterval` to control the reconnect interval, the `healthCheckInterval` to control the health check interval, and the `reconnectionMonitorTimeout` to control the reconnect timeout.

```dart
final websocket = Web3MQWebSocketManager(
  baseUrl: 'endpoint',
  reconnectionMonitorInterval: 10,
  healthCheckInterval: 20,
  reconnectionMonitorTimeout: 30,
);
```

:::note
The reconnect interval is random between 0.25-25 seconds base on `reconnectAttempt`.
:::

## Logger

By default, there is no logger. You can set the logger to print the log:

```dart
final websocket = Web3MQWebSocketManager(baseUrl: 'endpoint',  logger: yourLogger);
```

:::note
Currently we only support `Logger` from [Logging](https://pub.dev/packages/logging)
:::

## Singer

`Web3MQEd25519MessageSigner` is the default signer which signs the message with Ed25519. You can also provide your own `signer` to sign the message. The `signer` should implement the `MessageSinger` interface.

```dart
/// The message signer.
abstract class MessageSinger {
  /// Signs the message with the givien private key.
  Future<String> sign(String raw, Uint8List privateKey);
}
```

```dart
final websocket = Web3MQWebSocketManager(baseUrl: 'endpoint', signer: yourSigner);
```

## Channel Provier

`IOWebSocketChannel` is the default channel. You can also provide your own `channelProvider` to create the channel. The `channelProvider` is a function which returns a `WebSocketChannel`.

```dart
typedef WebSocketChannelProvider = WebSocketChannel Function(
  Uri uri, {
  Iterable<String>? protocols,
});
```

```dart
final websocket = Web3MQWebSocketManager(baseUrl: 'endpoint',  channelProvider: yourChannelProvider);
```

## Sending messages

The simpleast way to send a message is to call `sendText` or `sendBinary` method.

```dart
websocket.sendText('text', 'topic'); 
websocket.sendBinary(bytes, 'topic');
```

### Thread

If you need send a message in a thread, you can set the `threadId`.

```dart
websocket.sendText('text', 'topic', threadId: 'threadId');
```

### NeedStore

By default, the `needStore` is set to `true`, which means that the message will be stored on the web3mq network and can be retrieved by RESTful API.

:::note
Setting `needStore` to `true` may incur additional fees for the message sender. For more information, please consult with the sales team.
:::

To disable message storage, set the `needStore` parameter to `false`.

```dart
websocket.sendText('text', 'topic', needStore: false);
```

### ExtraData

You can attach additional data to the message by setting the `extraData` parameter.

```dart
websocket.sendText('text', 'topic', extraData: {'imageUrl': 'https://....'});
```
