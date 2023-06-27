---
sidebar_position: 2
---

# Notification

***Notification*** is a special type of message that can be marked as read and queried. Currently, there are the following types of notifications:

- `NotificationType.subscription`：Subscription message
- `NotificationType.receivedFriendRequest`：Received friend request
- `NotificationType.sendFriendRequest`：Sent friend request
- `NotificationType.groupInvitation`：Group invitation message
- `NotificationType.provider`：Provider information

## Subscribe

Subscribe a topic with `topicId`, then you can receive notifications from that `topic`.

```dart
client.subscribeTopic(topicId);
```

## Receive

You can use the following method to subscribe notifications from the web3mq server.

```dart
client.notificationStream.listen( (notifications) {
  // handle the notifications.
});
```

## Read Status

You may need other side to know if you have read the notification.

```dart
client.markNotificationsRead(notificationsIds);
```

## Query

You can query all historical notifications by types and pagination.

```dart
Page<Notification> res = await client.queryNotifications(type, pagination);
```
