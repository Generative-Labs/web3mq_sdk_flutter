import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:web3mq/web3mq.dart';

import 'chats_list_tile.dart';

/// A widget that displays a chat preview.
/// It shows the last message of the channel, the last message time, the unread
/// message count, avatar.
class ChatsPage extends StatefulWidget {
  const ChatsPage(
      {super.key, required this.title, required this.client, this.onTapChat});

  final String title;

  final Web3MQClient client;

  /// a event handler when user tap chat item
  final void Function(ChannelState)? onTapChat;

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
    widget.client.state.channelsStream.listen((event) {
      _onChannelListUpdate(event.values.toList());
    });
  }

  Future<void> _loadMoreChannels() async {
    if (_isLoading) {
      return;
    }

    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    widget.client
        .fetchChannels(paginationParams: Pagination(page: _page, size: 30))
        .listen((event) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              if (!_isLoading &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                // load more
                _loadMoreChannels();
              }
              return true;
            },
            child: ListView.builder(
              itemCount: _channels.length,
              itemBuilder: (context, index) {
                final item = _channels[index];
                return ChatsListTile(
                  channelState: item,
                  onTap: () {
                    widget.onTapChat?.call(item);
                  },
                );
              },
            )) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
