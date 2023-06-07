import 'package:flutter/material.dart';
import 'package:web3mq/web3mq.dart';
import 'package:web3mq_sdk_flutter_demo/chat_page.dart';
import 'package:web3mq_sdk_flutter_demo/main.dart';

class MessageListPage extends StatefulWidget {
  final String topicId;
  final String threadId;

  const MessageListPage(
      {super.key, required this.threadId, required this.topicId});

  @override
  State<StatefulWidget> createState() => _MessageListPageState();
}

class _MessageListPageState extends State<MessageListPage> {
  List<Message> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() {
    client
        .queryMessagesByTopic(widget.topicId, TimestampPagination(limit: 100),
            threadId: widget.threadId)
        .then((value) => _onMessagesChanged(value.result));
  }

  void _onMessagesChanged(List<Message> messages) {
    if (!mounted) return;
    setState(() {
      _messages = messages;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Message List'),
      ),
      body: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(), // new
        separatorBuilder: (context, index) => const Divider(),
        itemCount: _messages.length,
        itemBuilder: (BuildContext context, int index) {
          final message = _messages[index];
          return GestureDetector(
            onLongPressStart: (_) {
              // _presentBottomSheet(message.messageId);
            },
            child: ChatMessageCell(
              username: message.from,
              message: message.text ?? '',
              time: DateTime.fromMillisecondsSinceEpoch(message.timestamp),
              isSent: message.sendingStatus == MessageSendingStatus.sent,
              messageStatus: message.messageStatus?.status ?? '',
            ),
          );
        },
      ),
    );
  }
}
