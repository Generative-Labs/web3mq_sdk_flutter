import 'package:web3mq_websocket/src/models/pb/message.pb.dart';
import 'package:web3mq_websocket/src/models/ws_models.dart';

import 'notification.dart';

class EventType {
  /// Indicates any type of events
  static const String any = '*';

  /// Event sent when receiving a new message
  static const String messageNew = 'message.new';

  /// Event sent when a message is trying to send
  static const String messageSending = 'message.sending';

  /// Event sent when receiving a new message
  static const String notificationMessageNew = 'notification.message_new';

  /// Event sent when deleting a new message
  static const String messageDeleted = 'message.deleted';

  /// Event sent when updating a message
  static const String messageUpdated = 'message.updated';

  /// Event sent when a channel is deleted
  static const String channelDeleted = 'channel.deleted';

  /// Event sent when the connection status changes
  static const String connectionChanged = 'connection.changed';

  /// Event send when any channel be marked read
  static const String markRead = 'message.mark';
}

/// The class that contains the information about an event
class Event {
  /// The topic id to which the event belongs.
  final String? topicId;

  /// The node id in which the event has been sent.
  final String? nodeId;

  /// The type of the event
  ///
  /// [EventType] contains some predefined constant types.
  final String type;

  /// The message sent with the event
  final WSMessage? message;

  /// The notification sent with the event.
  final List<Notification>? notifications;

  /// The user id of who sent this event.
  final String? userId;

  /// The message status response.
  final Web3MQMessageStatusResp? messageStatusResponse;

  /// The date of creation of the event
  final DateTime createdAt;

  /// The number of unread messages for current user
  final int? totalUnreadCount;

  /// User total unread channels
  final int? unreadChannels;

  /// The connection status
  final ConnectionStatus? connectionStatus;

  Event(this.type,
      {DateTime? createdAt,
      this.topicId,
      this.nodeId,
      this.message,
      this.userId,
      this.notifications,
      this.messageStatusResponse,
      this.totalUnreadCount,
      this.unreadChannels,
      this.connectionStatus})
      : createdAt = createdAt?.toUtc() ?? DateTime.now().toUtc();

  factory Event.fromType(String type) {
    return Event(type);
  }

  factory Event.fromNotification(Web3MQMessageListResponse response) {
    final notifications =
        response.data.map((e) => Notification.fromMessageItem(e)).toList();
    return Event(EventType.notificationMessageNew,
        notifications: notifications);
  }

  factory Event.fromChatMessage(Web3MQRequestMessage message) {
    return Event(EventType.messageNew,
        message: WSMessage.fromWebSocketMessage(message));
  }

  factory Event.fromMessageUpdating(Web3MQMessageStatusResp response) {
    return Event(EventType.messageUpdated, messageStatusResponse: response);
  }

  factory Event.fromMessageSending(Web3MQRequestMessage message) {
    return Event(EventType.messageSending,
        message: WSMessage.fromWebSocketMessage(message));
  }

  @override
  String toString() {
    return "Event:{topicId:$topicId, nodeId:$nodeId, type:$type, message:$message, notification:$notifications}";
  }
}
