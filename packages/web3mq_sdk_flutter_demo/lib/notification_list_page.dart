import 'package:flutter/material.dart';
import 'package:web3mq/web3mq.dart';

import 'main.dart';

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
      _notifications.addAll(items);
      _onNotificationListUpdate();
    });
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

    _notifications.addAll(response.result);
    _onNotificationListUpdate();
  }

  void loadNotifications() {
    client.queryNotifications(
        NotificationType.all, const Pagination(page: 1, size: 30));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Notitfications"),
        ),
        body: NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              if (!_isLoading &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                _getNotifications();
              }
              return true;
            },
            child: ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final item = _notifications[index];
                return ListTile(
                  title: Text(item.payload.title),
                  subtitle: Text(item.payload.content),
                  trailing: Text(item.payload.timestamp.toIso8601String()),
                );
              },
            )) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
