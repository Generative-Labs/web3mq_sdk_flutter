import 'dart:async';

import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';
import 'package:web3mq/web3mq.dart';

/// The [ChannelStateManager] class is responsible for managing the state
/// associated with a specific channel, such as messages, unread message count,
/// and other channel-related events. It listens to events from the [Web3MQClient]
/// and updates the [ChannelState] accordingly, exposing it through streams.
class ChannelStateManager {
  final Web3MQClient _client;

  ChannelStateManager(this._client, final ChannelState channelState) {
    _channelStateController = BehaviorSubject.seeded(channelState);

    _loadChannelStateIfNeeded();
    _listenMessageNew();
    _listenMessageUpdated();
  }

  /// The channel state related to this client.
  ChannelState get channelState => _channelStateController.value;

  /// The channel state related to this client.
  ChannelState get _channelState => _channelStateController.value;

  /// The channel state related to this client as a stream.
  Stream<ChannelState> get channelStateStream => _channelStateController.stream;

  late BehaviorSubject<ChannelState> _channelStateController;

  set _channelState(ChannelState v) {
    _channelStateController.add(v);
    _client.persistenceClient?.updateChannelState(v);
  }

  /// Unread count getter as a stream.
  Stream<int> get unreadCountStream => _unreadCountController.stream;

  /// Unread count getter.
  int get unreadCount => _unreadCountController.value;

  final BehaviorSubject<int> _unreadCountController = BehaviorSubject<int>();

  /// Unread count getter as a stream.
  Stream<List<Message>> get messagesStream => _messagesController.stream;

  /// A paginated list of channel messages
  List<Message> get messages => _messagesController.value;

  final BehaviorSubject<List<Message>> _messagesController =
      BehaviorSubject<List<Message>>();

  final _subscriptions = CompositeSubscription();

  void _loadChannelStateIfNeeded() {}

  void _listenMessageNew() {
    _subscriptions.add(_on(EventType.messageNew).listen((event) {
      final message = event.message;
      if (null == message) return;
      if (_countMessageAsUnread(message)) {
        _unreadCountController.value += 1;
      }
    }));
  }

  void _listenMessageUpdated() {
    _subscriptions.add(_on(EventType.messageUpdated).listen((event) {
      final status = event.messageStatusResponse;
      if (null == status) return;
      final targetMessage = messages
          .firstWhereOrNull((message) => message.messageId == status.messageId);
      if (null != targetMessage) {
        final finalMessage = targetMessage.copyWith(
            sendingStatus: convertMessageStatusToSendingStatus(status));
        _updateMessage(finalMessage);
      }
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

  /// Updates the [message] in the state if it exists. Adds it otherwise.
  void _updateMessage(Message message) {
    final newMessages = [...messages];
    final oldIndex =
        newMessages.indexWhere((m) => m.messageId == message.messageId);
    if (oldIndex != -1) {
      newMessages[oldIndex] = message;
    } else {
      newMessages.add(message);
    }
    _channelState = _channelState.copyWith(
      messages: newMessages..sort(_sortByCreatedAt),
      channel: _channelState.channel.copyWith(
        lastMessageAt: message.createdAt,
      ),
    );
  }

  /// Sorts the messages by created at in descending order
  int _sortByCreatedAt(Message a, Message b) =>
      a.createdAt.compareTo(b.createdAt);

  bool _countMessageAsUnread(WSMessage message) {
    return message.threadId != null;
  }

  Stream<Event> _on([
    String? eventType,
    String? eventType2,
    String? eventType3,
    String? eventType4,
  ]) =>
      _client
          .on(
            eventType,
            eventType2,
            eventType3,
            eventType4,
          )
          .where((e) => e.topicId == _channelState.channel.channelId);
}
