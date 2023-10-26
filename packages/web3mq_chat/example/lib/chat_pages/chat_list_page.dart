// ignore_for_file: avoid_print

import 'dart:collection';

import 'package:example/utils/alert_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:web3mq/web3mq.dart';

import '../main.dart';
import 'chat_page.dart';

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

  final theTestGroupId = 'group:8d7851d94641d6b8b7986cc9030c661dffb900ef';

  @override
  void initState() {
    super.initState();
    if (!mounted) return;

    _listenChannels();
    _ensureJoinedATestGroup(theTestGroupId);
  }

  // ensure joined a test group
  void _ensureJoinedATestGroup(String groupId) {
    client.groups().then((value) {
      final result = value.result;
      if (result.isEmpty) {
        client.joinGroup(groupId);
      } else {
        bool joined = false;
        for (int i = 0; i < result.length; i++) {
          if (result[i].groupId == groupId) {
            joined = true;
            break;
          }
        }
        if (!joined) {
          client.joinGroup(groupId);
        }
      }
    });
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

  void _onCreateGroup() async {
    final groupName = await AlertUtils.showTextField(
        'Creat Group', null, 'Group Name', context);
    if (groupName == null) return;
    await client.createGroup(groupName, null);
  }

  void _onJoinGroup() async {
    final groupId =
        await AlertUtils.showTextField('Join Group', null, 'GroupId', context);
    if (groupId == null || groupId.isEmpty) return;
    await client.joinGroup(groupId);
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
                  decoration: const InputDecoration(hintText: 'UserId'),
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

  final formatter = DateFormat('MM/dd HH:mm');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          PopupMenuButton<String>(
            // add offset below the button
            offset: const Offset(0, 44),
            icon: const Icon(Icons.add),
            onSelected: (String result) {
              switch (result) {
                case 'Create group':
                  _onCreateGroup();
                  break;
                case 'Join group':
                  _onJoinGroup();
                  break;
                case 'Send message':
                  _onShowPublishMessageToTopicDialog();
                  break;
                default:
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Create group',
                child: Text('Create group'),
              ),
              const PopupMenuItem<String>(
                value: 'Join group',
                child: Text('Join group'),
              ),
              const PopupMenuItem<String>(
                value: 'Send message',
                child: Text('Send message'),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          _page = 1;
          return _getChannels();
        },
        child: ListView.separated(
          separatorBuilder: (context, index) => const Divider(),
          // add divier
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
              leading: Image.network(
                  'https://cdn.stamp.fyi/avatar/${item.channel.topic}?s=300'),
              title: Text(item.channel.name),
              subtitle: Text(item.lastMessage?.text ?? ''),
              // timestamp to string
              trailing: item.lastMessage?.timestamp != null
                  ? Text(formatter.format(DateTime.fromMillisecondsSinceEpoch(
                      item.lastMessage?.timestamp ?? 0)))
                  : null,
            );
          },
        ),
      ),
    );
  }
}
