# example

A Flutter project to demonstrate the use of `web3mq_chat` package.

## Structure

The project is a standard Flutter project with the following structure:

```html
example
├── android
│   └── ...
├── ios
│   └── ...
├── linux
│   └── ...
├── macos
│   └── ...
├── lib
│   ├── main.dart
│   ├── chat_pages
│   │   └── ...
│   ├── connect_page
│   │   └── ...
│   ├── utils
│   │   └── ...
│   └── wallet_connector
│       └── ...
└── test
└── pubspec.yaml
```

The `lib` folder contains the project's main code. The `main.dart` file is the application's entry point and contains setups for `Web3MQClient`. The `chat_pages` folder contains the code for the chat list and chat pages. The `connect_page` folder contains the code for creating credentials and generating sessionkey. The utils folder contains the code for the `AlertUtils`. The `wallet_connector` folder contains two example implementations of the `WalletConnector` interface: one implemented with WalletConnectV2 and the other implemented as a built-in wallet for ease of internal debugging.
