# QuickStart

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

## Initial the SDK

For an API-key, see
detail:  [https://docs.web3mq.com/docs/Web3MQ-API/dapp/create_dapp/](https://docs.web3mq.com/docs/Web3MQ-API/dapp/create_dapp/)

```dart
final client = DappConnectClient(
    'App-Key',
    baseURL: DevEndpoint.jp1,
    appMedata);
// make the real connection.
await client.connectUser();
```

:::tip
You can customize the `baseURL`, which is set to `DevEndpoint.jp1` by default, or
use `UtilsApi().findTheLowestLatencyEndpoint()` to get the endpoint with the lowest latency and assign it to `baseURL`.
:::

## Session management

Session is a object which contains the information of a connection between dapp and wallet. It contains a `topic` which
is a unique identifier of a session. You can use it to send request to wallet.

Session management is enabled by default. It means that the SDK will automatically cache every infomation on session
such as requests and response. You can get the session list by calling `client.sessions`. You can clear all the sessions
by calling `client.cleanup()`, or just remove a session by calling `client.deleteSession(topic)`.

## For Wallet

### Receiving Session proposal

```dart
// 1. register a session proposal subsciber  
client.sessionProposalStream.listen((proposal) {
    // 1.you should present a model to show that proposal, and user can 
    // choose approve or reject.
  
    // 2. in case approve. you should prepare your `SessionNamespaces` which is 
    // the namespaces your wallet supports.
    try await client.approveSessionProposal(proposal.id, sessionNamespaces);

    // 3. in case reject.
    try await client.rejectSessionProposal(proposal.id);

});

// when receives a deeplink 
final uri = DappConnectURI(string: urlString);
client.pairURI(uri);
```

### Receiving Request

```dart
  dappConnectClient.requestStream.listen((request) {
    // handle the request
    switch (request.method) {
      case 'personal_sign':
        // as a sign request, the params should be a string array
        // which presents [message, address, password]
        final params = request.params;
        // call your sign function and get the signature
        final signature = yourSign(params);
        // then send response
        dappConnectClient.sendSuccessResponse(request, signature);
        // or error
        dappConnectClient.sendErrorResponse(
            request, 50001, 'some error message');
        break;
      default:
    }
  });
```

### Sending response

```dart
// for error.
await client.sendErrorResponse(request, code, message);
// for success.
await client.sendSuccessResponse(request, result);
```

## For Dapp

### Sending Session Proposal

Before you can send request to the wallet, you need to offer a `SessionProposal` to the wallet by calling this:

```dart
  try {
    final session = await dappConnectClient.connectWallet(requiredNamespaces);
  } on DappConnectError {
    // handle timeout error 
  } on RPCError {
    // handle rpc error
  }
```

Above code will generates a `SessionProposal` (which supports CAIPs ) and send it to a wallet via deepLink. If wallet
approved the proposal, the function returns with a `Session` object, otherwise throws  `RPCError` which contains a error
code and message. If wallet side did nothing for 3 minutes, the function throws a `TimeoutError`.

### Session List

```dart
final sessions = await client.sessions;
```

### Sending Request

```dart
// 1. prepare your request content, could be any obejct which inherits `Codable`
final params = "just a string";
final method = "a method name";

// get the topic from `session.topic` and send the request
await client.sendRequest(session.topic, method, params);
```

### Receiving Response

```dart
  try {
    final response = await client.sendRequest(session.topic, method, params);
  } on DappConnectError {
    // handle timeout error 
  } on RPCError {
    // handle rpc error
  }
```

### Personal_sign

we provider a convince function for `personal_sign` , so you can easily get the signature.

```dart
do {
  final signature = await client.personalSign(message, address, topic);
} on DappConnectError {
    // handle timeout error 
} on RPCError {
    // handle rpc error
} catch(e) {
    // handle unknown error
}
```
