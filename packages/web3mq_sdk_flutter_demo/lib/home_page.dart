import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web3mq/web3mq.dart';
import 'package:web3mq_sdk_flutter_demo/chats_page.dart';
import 'package:web3mq_sdk_flutter_demo/contacts_page.dart';
import 'package:web3mq_sdk_flutter_demo/notification_list_page.dart';
import 'package:web3mq_sdk_flutter_demo/profile_page.dart';
import 'package:web3mq_sdk_flutter_demo/topic_page.dart';

import 'main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.user});

  final User user;

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  final PageController pageController = PageController(initialPage: 0);

  String _title = "";

  @override
  void initState() {
    super.initState();
    if (!mounted) return;

    client.connectUser(widget.user);
    _listenConnectionStatus();
  }

  void _listenConnectionStatus() {
    client.wsConnectionStatusStream.listen((event) {
      switch (event) {
        case ConnectionStatus.connected:
          _onChangeTitle("Connected");
          break;
        case ConnectionStatus.connecting:
          _onChangeTitle("Connecting");
          break;
        case ConnectionStatus.disconnected:
          _onChangeTitle("Disconnected");
          break;
      }
    });
  }

  void _onChangeTitle(String newTitle) {
    setState(() {
      _title = "Chats($newTitle)";
    });
  }

  Widget _itemPageByIndex(int index) {
    switch (index) {
      case 0:
        return ChatsPage(title: _title);
      case 1:
        return const ContactsPage();
      case 2:
        return const NotificationListPage();
      case 3:
        return const TopicPage();
      case 4:
        return const ProfilePage();
      default:
        return const Text('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        // height: 30,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: 'Contacts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.topic),
            label: 'Topic',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'User',
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return _itemPageByIndex(index);
      },
    );
  }
}
