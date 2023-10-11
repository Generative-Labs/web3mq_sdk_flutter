import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:web3mq/src/api/responses.dart';
import 'package:web3mq/src/models/channel_state.dart';
import 'package:web3mq_websocket/web3mq_websocket.dart';

import '../models/message_sending_status.dart';
import '../models/user.dart';
import '../utils/signer.dart';

import 'client.dart';

class ClientState {
  /// Creates a new instance listening to events and updating the state
  ClientState(this._client, this._signer);

  CompositeSubscription? _eventsSubscription;

  final Web3MQClient _client;

  final Signer _signer;

  /// The current unread channels count
  int get unreadChannels => _unreadChannelsController.value;

  /// The current unread channels count as a stream
  Stream<int> get unreadChannelsStream => _unreadChannelsController.stream;

  /// The current total unread messages count
  int get totalUnreadCount => _totalUnreadCountController.value;

  /// The current total unread messages count as a stream
  Stream<int> get totalUnreadCountStream => _totalUnreadCountController.stream;

  /// The current list of channels in memory as a stream
  Stream<Map<String, ChannelState>> get channelsStream =>
      _channelsController.stream;

  /// The current list of channels in memory
  Map<String, ChannelState> get channels => _channelsController.value;

  /// The current user as a stream
  Stream<User?> get currentUserStream => _currentUserController.stream;

  /// Used internally for optimistic update of unread count
  set totalUnreadCount(int unreadCount) {
    _totalUnreadCountController.add(unreadCount);
  }

  /// Used internally for optimistic update of unread count
  set unreadChannelsCount(int unreadChannelsCount) {
    _unreadChannelsController.add(unreadChannelsCount);
  }

  set channels(Map<String, ChannelState> newChannels) {
    // sort by last message at
    List<MapEntry<String, ChannelState>> sortedChannels = newChannels.entries
        .toList()
      ..sort((a, b) => (DateTime.fromMillisecondsSinceEpoch(
              b.value.lastMessage?.timestamp ?? 0))
          .compareTo(DateTime.fromMillisecondsSinceEpoch(
              a.value.lastMessage?.timestamp ?? 0)));
    Map<String, ChannelState> sortedMap = Map.fromEntries(sortedChannels);
    _channelsController.add(sortedMap);
  }

  /// Adds a list of channels to the current list of cached channels
  void addChannels(Map<String, ChannelState> channelMap) {
    final newChannels = {
      ...channels,
      ...channelMap,
    };
    channels = newChannels;
  }

  /// Starts listening to the client events.
  void subscribeToEvents() {
    if (_eventsSubscription != null) {
      cancelEventSubscription();
    }
    _eventsSubscription = CompositeSubscription();

    _eventsSubscription!
      ..add(_client
          .on()
          .map((event) => event.unreadChannels)
          .whereType<int>()
          .listen((count) {
        _unreadChannelsController.add(count);
      }))
      ..add(_client
          .on()
          .map((event) => event.totalUnreadCount)
          .whereType<int>()
          .listen((count) {
        _totalUnreadCountController.add(count);
      }));

    _listenAllChannelsRead();

    _listenChannelDeleted();

    _listenMessageAdd();

    _listenMessageUpdated();
  }

  /// Stops listening to the client events.
  void cancelEventSubscription() {
    if (_eventsSubscription != null) {
      _eventsSubscription!.cancel();
      _eventsSubscription = null;
    }
  }

  /// Pauses listening to the client events.
  void pauseEventSubscription([Future<void>? resumeSignal]) {
    _eventsSubscription?.pause(resumeSignal);
  }

  void _listenAllChannelsRead() {
    _eventsSubscription?.add(
      _client.on(EventType.markRead).listen((event) {
        if (event.topicId == null) {}
      }),
    );
  }

  void _listenChannelDeleted() {
    _eventsSubscription?.add(
      _client
          .on(
        EventType.channelDeleted,
      )
          .listen((Event event) async {
        final topic = event.topicId!;

        // remove from memory
        channels.remove(topic);

        // remove from persistence
        await _client.persistenceClient?.deleteChannels([topic]);
      }),
    );
  }

  void _updateLastSync(int timestamp) {
    _client.persistenceClient
        ?.updateLastSyncAt(DateTime.fromMillisecondsSinceEpoch(timestamp));
  }

  void _listenMessageAdd() {
    _eventsSubscription?.add(
      _client.on(EventType.messageNew).listen((Event event) async {
        final wsMessage = event.message;
        if (null == wsMessage) return;
        final message = Message.fromWSMessage(wsMessage)
            .copyWith(sendingStatus: MessageSendingStatus.sent);
        updateStateByMessagesIfNeeded([message]);
        _updateLastSync(message.timestamp);
      }),
    );
    _eventsSubscription?.add(
      _client.on(EventType.messageSending).listen((Event event) async {
        final wsMessage = event.message;
        if (null == wsMessage) return;
        final message = Message.fromWSMessage(wsMessage)
            .copyWith(sendingStatus: MessageSendingStatus.sending);
        updateStateByMessagesIfNeeded([message]);
      }),
    );
  }

  void _listenMessageUpdated() {
    _eventsSubscription
        ?.add(_client.on(EventType.messageUpdated).listen((event) {
      final status = event.messageStatusResponse;
      if (null == status) return;
      _client.persistenceClient?.getMessageById(status.messageId).then((value) {
        if (null == value) return;
        final finalMessage = value.copyWith(
            sendingStatus: convertMessageStatusToSendingStatus(status));
        //
        updateStateByMessagesIfNeeded([finalMessage]);
      });
    }));
  }

  MessageSendingStatus convertMessageStatusToSendingStatus(
      Web3MQMessageStatusResp messageStatusResp) {
    if (messageStatusResp.messageStatus == 'received') {
      return MessageSendingStatus.sent;
    } else {
      return MessageSendingStatus.failed;
    }
  }

  void updateStateByMessagesIfNeeded(List<Message> messages) async {
    final userId = currentUser?.userId;
    if (messages.isEmpty) return;
    if (userId == null) return;

    messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    // if there's no channel exist for this message, create a new one
    Map<String, ChannelState> channelMap = {};
    List<ChannelState> channelStates = [];
    for (final message in messages) {
      final channelId = message.channelIdByCurrentUserId(userId);
      ChannelState channelState;
      if (channels.containsKey(channelId)) {
        channelState = channels[channelId]!;
        if (_shouldCountMessageAsUnread(message)) {
          channelState.channel.unreadMessageCount += 1;
        }
        // insert message to the right position or replace if the same id exists
        int index = channelState.messages
            .indexWhere((m) => m.messageId == message.messageId);
        if (index != -1) {
          channelState.messages[index] = message;
        } else {
          index = channelState.messages
              .indexWhere((m) => m.timestamp > message.timestamp);
          if (index != -1) {
            channelState.messages.insert(index, message);
          } else {
            channelState.messages.add(message);
          }
        }
      } else {
        final channelModel = _createChannelModelByMessage(message, channelId);
        channelState = ChannelState(channel: channelModel, messages: [message]);
      }
      channelMap[channelId] = channelState;
      channelStates.add(channelState);
    }

    // add the channel to the channel list
    addChannels(channelMap);

    // update the channel persistence if needed
    _client.persistenceClient?.updateChannelStates(channelStates);
  }

  String _channelTypeByTopic(String topic) {
    return topic.contains('user')
        ? 'user'
        : topic.contains('group')
            ? 'group'
            : 'topic';
  }

  ChannelModel _createChannelModelByMessage(Message message, String channelId) {
    final channelType = _channelTypeByTopic(message.topic);
    final channelName = channelId;

    /// count unread count
    final unreadCount = _shouldCountMessageAsUnread(message) ? 1 : 0;

    return ChannelModel(
        message.topic,
        channelType,
        channelId,
        channelType,
        channelName,
        null,
        DateTime.fromMillisecondsSinceEpoch(message.timestamp),
        null,
        unreadMessageCount: unreadCount);
  }

  ///
  String? get currentNodeId => _currentNodeIdController.valueOrNull;

  ///
  Stream<String?> get currentNodeIdStream => _currentNodeIdController.stream;

  /// The current user
  User? get currentUser => _currentUserController.valueOrNull;

  final _currentNodeIdController = BehaviorSubject<String?>();

  /// Sets the current node id
  set currentNodeId(String? nodeId) {
    _currentNodeIdController.add(nodeId);
  }

  /// Sets the user currently interacting with the client
  /// note: this fully overrides the [currentUser]
  set currentUser(User? user) {
    _currentUserController.add(user);
    _signer.updateUser(user);
    _setupAdditionalHeadersOnCurrentUserUpdate(user);
  }

  Future<void> _setupAdditionalHeadersOnCurrentUserUpdate(User? user) async {
    if (null == user) {
      Web3MQClient.additionalHeaders = {};
    } else {
      final keyPair = KeyPair.fromPrivateKeyHex((user.sessionKey));
      final publicHex = await keyPair.publicKeyHex;
      Web3MQClient.additionalHeaders = {
        "api-version": 2,
        "web3mq-request-pubkey": publicHex,
        "didkey": "${user.did.type}:${user.did.value}"
      };
    }
  }

  final _channelsController =
      BehaviorSubject<Map<String, ChannelState>>.seeded({});
  final _currentUserController = BehaviorSubject<User?>();
  final _unreadChannelsController = BehaviorSubject<int>.seeded(0);
  final _totalUnreadCountController = BehaviorSubject<int>.seeded(0);

  bool _shouldCountMessageAsUnread(Message message) {
    return message.sendingStatus == MessageSendingStatus.sent &&
        message.from != currentUser?.userId &&
        message.messageStatus?.status != 'read';
  }

  void dispose() {
    _currentUserController.close();
    _currentNodeIdController.close();
    _unreadChannelsController.close();
    _totalUnreadCountController.close();
    _channelsController.close();
  }
}
