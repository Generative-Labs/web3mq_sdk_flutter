import 'dart:async';

import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:web3mq/src/api/notification_api.dart';
import 'package:web3mq/src/api/user_api.dart';
import 'package:web3mq/src/api/web3mq_service.dart';
import 'package:web3mq/src/client/client_state.dart';
import 'package:web3mq/src/error/error.dart';
import 'package:web3mq/src/ws/models/connection_status.dart';
import 'package:web3mq/src/ws/models/event.dart';
import 'package:web3mq/src/ws/models/user.dart';
import 'package:web3mq/src/ws/websocket.dart';

import 'mocks.dart';

class FakeUser extends Fake implements User {}

class FakeService extends Fake implements Web3MQService {
  NotificationApi? _notification;

  UserApi? _user;

  /// Api dedicated to users operations
  @override
  NotificationApi get notification => _notification ?? MockNotificationApi();

  @override
  UserApi get user => _user ?? MockUserApi();
}

class FakeClientState extends Fake implements ClientState {
  @override
  User? get currentUser => User(
      "user:7c0b577c0786e51f90522f833bf8ac8749cb32d681e7eccedba1dcc45f9a5173",
      DID("eth",
          "7c0b577c0786e51f90522f833bf8ac8749cb32d681e7eccedba1dcc45f9a5173"),
      "0bf8eae8be0e7d364710ad1027598bb273e8122f75d4b70886f6ad855c03a991");
}

class FakeEvent extends Fake implements Event {}

class FakeWebSocket extends Fake implements Web3MQWebSocket {
  BehaviorSubject<ConnectionStatus>? _connectionStatusController;

  BehaviorSubject<ConnectionStatus> get connectionStatusController =>
      _connectionStatusController ??=
          BehaviorSubject.seeded(ConnectionStatus.disconnected);

  set connectionStatus(ConnectionStatus value) {
    connectionStatusController.add(value);
  }

  @override
  ConnectionStatus get connectionStatus => connectionStatusController.value;

  @override
  Stream<ConnectionStatus> get connectionStatusStream =>
      connectionStatusController.stream;

  @override
  Completer<Event>? connectionCompleter;

  @override
  Future<Event> connect(User user) async {
    connectionStatus = ConnectionStatus.connecting;
    final event = Event(EventType.connectionChanged);
    connectionCompleter = Completer()..complete(event);
    connectionStatus = ConnectionStatus.connected;
    return connectionCompleter!.future;
  }

  @override
  void disconnect() {
    connectionStatus = ConnectionStatus.disconnected;
    connectionCompleter = null;
    _connectionStatusController?.close();
    _connectionStatusController = null;
  }
}

class FakeWebSocketWithConnectionError extends Fake implements Web3MQWebSocket {
  BehaviorSubject<ConnectionStatus>? _connectionStatusController;

  BehaviorSubject<ConnectionStatus> get connectionStatusController =>
      _connectionStatusController ??=
          BehaviorSubject.seeded(ConnectionStatus.disconnected);

  set connectionStatus(ConnectionStatus value) {
    connectionStatusController.add(value);
  }

  @override
  ConnectionStatus get connectionStatus => connectionStatusController.value;

  @override
  Stream<ConnectionStatus> get connectionStatusStream =>
      connectionStatusController.stream;

  @override
  Completer<Event>? connectionCompleter;

  @override
  Future<Event> connect(User user) async {
    connectionStatus = ConnectionStatus.connecting;
    const error = Web3MQWebSocketError('Error Connecting');
    connectionCompleter = Completer()..completeError(error);
    return connectionCompleter!.future;
  }

  @override
  void disconnect() {
    connectionStatus = ConnectionStatus.disconnected;
    connectionCompleter = null;
    _connectionStatusController?.close();
    _connectionStatusController = null;
  }
}
