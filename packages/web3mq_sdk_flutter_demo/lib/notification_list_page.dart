import 'package:flutter/material.dart';
import 'package:web3mq/web3mq.dart';

import 'main.dart';
import 'utils/global_alert.dart';

class NotificationListPage extends StatefulWidget {
  const NotificationListPage({super.key});

  @override
  State<NotificationListPage> createState() => _NotificationListPageState();
}

class _NotificationListPageState extends State<NotificationListPage> {
  final _notifications = <NotificationQueryResponse>[];
  bool _isLoading = false;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    _getNotifications();
    _listenClientNotifications();
  }

  void _onNotificationListUpdate() {
    if (!mounted) return;
    setState(() {
      _notifications
          .sort((a, b) => b.payload.timestamp.compareTo(a.payload.timestamp));
    });
  }

  void _listenClientNotifications() {
    client.notificationStream.listen((event) {
      final items = event
          .map((e) => NotificationQueryResponse.fromNotificationMessage(e));
      _addNotifications(items);
      _onNotificationListUpdate();
    });
  }

  void _addNotifications(Iterable<NotificationQueryResponse> list) {
    for (var item in list) {
      if (!_notifications.contains(item)) {
        _notifications.add(item);
      }
    }
  }

  Future<void> _getNotifications() async {
    if (_isLoading) {
      return;
    }

    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    final response = await client.queryNotifications(
        NotificationType.all, Pagination(page: _page, size: 30));
    setState(() {
      _isLoading = false;
      _page++;
    });
    _addNotifications(response.result);
    _onNotificationListUpdate();
  }

  void loadNotifications() {
    client.queryNotifications(
        NotificationType.all, const Pagination(page: 1, size: 30));
  }

  Future<void> agreeFriendRequest(String userId) async {
    try {
      await client.follow(userId, null);
    } catch (e) {
      GlobalAlertDialog.showAlertDialog(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Notitfications"),
        ),
        body: ListView.builder(
          itemCount: _notifications.length,
          itemBuilder: (context, index) {
            final item = _notifications[index];
            return ListTile(
              title: Text(item.payload.title),
              subtitle: Text(item.payload.content),
              trailing: item.payload.type ==
                      NotificationType.receivedFriendRequest.value
                  ? ElevatedButton(
                      onPressed: () async {
                        // Handle the "Agree" button click event here
                        await agreeFriendRequest(item.from);
                      },
                      child: const Text("Agree"),
                    )
                  : null,
            );
          },
        ));
  }
}
