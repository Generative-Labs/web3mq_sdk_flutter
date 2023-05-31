import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:web3mq/web3mq.dart';
import 'package:web3mq_sdk_flutter_demo/chat_page.dart';

import 'main.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  List<ChannelState> _channels = [];
  bool _isLoading = false;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    if (!mounted) return;

    _listenChannels();
  }

  void _onChannelListUpdate(List<ChannelState> list) {
    if (!mounted) return;
    setState(() {
      _channels = list;
    });
  }

  void _listenChannels() {
    client.state.channelsStream.listen((event) {
      _onChannelListUpdate(event.values.toList());
    });
  }

  Future<void> _getChannels() async {
    if (_isLoading) {
      return;
    }

    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    client.fetchChannels().listen((event) {
      setState(() {
        _isLoading = false;
        _page++;
      });
      if (event.isEmpty) {
        return;
      }
      if (_page == 1) {
        _onChannelListUpdate(event);
      } else {
        List<ChannelState> list = _channels;
        LinkedHashSet<ChannelState> set = LinkedHashSet.from(list);
        set.addAll(event);
        list = set.toList();
        _onChannelListUpdate(list);
      }
    });
  }

  void loadNotifications() {
    client.queryNotifications(
        NotificationType.all, const Pagination(page: 1, size: 30));
  }

  void _onCreateChat(String topic, String text) {
    client.sendText(text, topic);
    _topicController.clear();
    _contentController.clear();
  }

  final _topicController = TextEditingController();

  final _contentController = TextEditingController();

  // present a dialog to enter the topic and text content
  // then call client.sendText
  Future<void> _onShowPublishMessageToTopicDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          key: UniqueKey(),
          title: const Text('Sending message'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(hintText: 'Topic'),
                  controller: _topicController,
                ),
                TextField(
                  decoration:
                      const InputDecoration(hintText: 'Message Content'),
                  controller: _contentController,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Send'),
              onPressed: () {
                final topic = _topicController.text;
                final text = _contentController.text;
                _onCreateChat(topic, text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            IconButton(
              onPressed: _onShowPublishMessageToTopicDialog,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              if (!_isLoading &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                _getChannels();
              }
              return true;
            },
            child: ListView.builder(
              itemCount: _channels.length,
              itemBuilder: (context, index) {
                final item = _channels[index];
                return ListTile(
                  onTap: () {
                    if (!mounted) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatPage(
                                topicId: item.channel.topic,
                                title: item.channel.channelId,
                              )),
                    );
                  },
                  leading: Text(item.channel.unreadMessageCount.toString()),
                  title: Text(item.channel.name),
                  subtitle: Text(item.lastMessage?.text ?? ''),
                  trailing: Text(item.lastMessage?.timestamp.toString() ?? ''),
                );
              },
            )) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
