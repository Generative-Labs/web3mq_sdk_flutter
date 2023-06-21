# web3mq_http

web3mq_http is a Web3MQ JSON-RPC client based on the HTTP protocol, using the http package to send requests and parse responses. It supports all standard Web3mq methods, including user registerion, chats and notification queries.

## Installation

To use web3mq_http, add it to your pubspec.yaml file:

```yaml
dependencies:
  web3mq_http: ^0.1.0-dev.1
```

## Usage

```dart
  final service = Web3MQService('{apiKey}');

  // If you want to execute the registration and login interfaces,
  // we strongly recommend that you use the web3mq package.
  // Once you have the login credential User, you can use the service like above

  final aUser = User('userId', DID('type', 'value'), Uint8List.fromList([]));
  await service.connectUser(aUser);

  // fetch chats:
  final chats = await service.chat.queryChannels(Pagination(size: 20));
  print(chats);
```
