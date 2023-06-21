
# web3mq_websocket

A lightware websocket tool to communicate with web3mq.

## Installation

To use web3mq_websocket, add it to your pubspec.yaml file:

```yaml
dependencies:
  web3mq_websocket: ^0.1.0-dev.1
```

## Features

- Reconnect automumaccly.
- Customisable data model.
- Completely methods for web3mq RESTful api.

## Usage

```dart
  final websocket = Web3MQWebSocketManager(baseUrl: 'endpoint');

  // lisnten the new message stream.
  websocket.messageStream.listen((event) {});

  // lisnten the new notification stream.
  websocket.notificationStream.listen((event) {});

  // lisnten the connection status stream.
  websocket.connectionStatusStream.listen((event) {});

  /// listen the sending status stream.
  websocket.messageUpdateStream.listen((event) {});

  // replace with your own user
  final user = User('userId', DID('type', 'value'), Uint8List.fromList([]));
  await websocket.connect(user);
  websocket.sendText('text', 'topic');
```
