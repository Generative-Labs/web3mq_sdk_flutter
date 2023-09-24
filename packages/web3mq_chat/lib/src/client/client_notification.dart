part of 'client.dart';

///
extension NotificationExtension on Web3MQClient {
  /// Query for the historical notifications with [NotificationType] and [Pagination].
  Future<Page<NotificationQueryResponse>> queryNotifications(
          NotificationType type, Pagination pagination) =>
      _service.notification.query(type, pagination);

  /// Marks notifications as read.
  Future<void> markNotificationRead(List<String> notificationIds) =>
      _service.notification.updateReadStatus(notificationIds, ReadStatus.read);
}
