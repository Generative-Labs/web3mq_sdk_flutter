<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

# web3mq_websocket

A lightware websocket tool to communicate with web3mq.

## Features

- Reconnect automumaccly.
- Customisable data model.
- Completely methods for web3mq RESTful api.

## Getting started

## Usage

```dart
final websocketManager = Web3MQSocketManager(endpoint: '{Endpoint}');
final message = Web3MQChatMessage(content: 'hello, world!', topic: '{topic}');
websocketManager.send(message);
```
