import 'package:flutter/material.dart';
import 'package:web3mq/web3mq.dart';
import 'package:web3mq_sdk_flutter_demo/chat_page.dart';
import 'package:web3mq_sdk_flutter_demo/main.dart';

class ThreadListPage extends StatefulWidget {
  const ThreadListPage({super.key, required this.topicId});

  final String topicId;

  @override
  State<StatefulWidget> createState() => _ThradListPageState();
}

class _ThradListPageState extends State<ThreadListPage> {
  List<Thread> _threadList = [];

  @override
  void initState() {
    super.initState();
    _loadThreadList();
  }

  void _loadThreadList() {
    client
        .threadList(widget.topicId)
        .then((value) => _onThreadListUpdate(value));
  }

  void _onThreadListUpdate(List<Thread> list) {
    if (!mounted) return;
    setState(() {
      _threadList = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thread List'),
      ),
      body: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(), // new
        separatorBuilder: (context, index) => const Divider(),
        itemCount: _threadList.length,
        itemBuilder: (BuildContext context, int index) {
          final thread = _threadList[index];
          return GestureDetector(
            onTap: () {
              // MessageListPage
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatPage(
                          title: thread.threadName ?? '',
                          topicId: thread.topicId,
                          threadId: thread.threadId,
                        )),
              );
            },
            child: ListTile(
              leading: Text(thread.threadName ?? ''),
              title: Text(thread.threadId),
              trailing: Text(thread.timestamp.toString()),
            ),
          );
        },
      ),
    );
  }
}
