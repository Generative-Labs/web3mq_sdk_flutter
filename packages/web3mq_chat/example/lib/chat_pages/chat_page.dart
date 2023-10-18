import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import 'package:web3mq/web3mq.dart';

import '../main.dart';

class ChatPage extends StatefulWidget {
  const ChatPage(
      {super.key, required this.title, required this.topicId, this.threadId});

  final String title;
  final String topicId;
  final String? threadId;

  @override
  State<StatefulWidget> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();

  List<Message> _messages = [];

  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    // fetches messages from server
    client
        .queryMessagesByTopic(widget.topicId, TimestampPagination(limit: 20))
        .then((value) {
      final result = value.result;
      _onMessagesUpdate(result);
      _markAllMessagesRead(result);
    });

    _listenMessages();
    _listenMessageUpdated();
  }

  void _markAllMessagesRead(List<Message> messages) {
    List<String> unreadMessageIds = [];
    for (int i = 0; i < messages.length; i++) {
      if (messages[i].messageStatus?.status != 'read') {
        unreadMessageIds.add(messages[i].messageId);
      }
    }
    if (unreadMessageIds.isNotEmpty) {
      client.markAllMessagesToReadByTopic(widget.topicId, unreadMessageIds);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  bool isFirstLoad = true;

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: isFirstLoad
            ? const Duration(microseconds: Duration.microsecondsPerMillisecond)
            : const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      isFirstLoad = false;
    });
  }

  void _listenMessages() {
    client.newMessageStream.listen((message) {
      if (message.topic == widget.topicId &&
          isThreadIdEqual(widget.threadId, message.threadId)) {
        _messages.add(message);
        _onMessagesUpdate(_messages);
      }
    });
  }

  bool isThreadIdEqual(String? threadIdA, String? threadIdB) {
    return threadIdA == threadIdB;
  }

  void _listenMessageUpdated() {
    client.messageStatusUpdingStream.listen((status) {
      final tempMessages = _messages;
      final index = tempMessages
          .indexWhere((element) => element.messageId == status.messageId);
      if (index != -1) {
        final oldMessage = tempMessages[index];
        final finalMessage = oldMessage.copyWith(
            sendingStatus: (status.messageStatus == 'received' ||
                    status.messageStatus == 'read')
                ? MessageSendingStatus.sent
                : MessageSendingStatus.failed);
        tempMessages[index] = finalMessage;
        _onMessagesUpdate(tempMessages);
      }
    });
  }

  void _onMessagesUpdate(List<Message> messages) {
    if (!mounted) return;
    setState(() {
      _messages = messages;
      _scrollToBottom();
    });
  }

  void _sendMessage(String text) {
    client.sendText(text, widget.topicId).then((value) {
      final sendingMessage =
          value.copyWith(sendingStatus: MessageSendingStatus.sending);
      final tempMessages = _messages;
      tempMessages.add(sendingMessage);
      _onMessagesUpdate(tempMessages);
    });
  }

  void _presentBottomSheet(String messageId) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 100,
          child: Column(
            children: [
              ListTile(
                title: const Text('Create Thread'),
                onTap: () {
                  // create thread
                  client
                      .createThread(widget.topicId, messageId, '')
                      .then((value) {
                    // create success
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onLongPress: () {
            showMenu(
              position: RelativeRect.fill,
              context: context,
              items: [
                PopupMenuItem(
                  child: const Text('Copy'),
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: widget.title));
                  },
                ),
              ],
            );
          },
          child: Text(widget.title),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                // new
                separatorBuilder: (context, index) => const Divider(),
                itemCount: _messages.length,
                itemBuilder: (BuildContext context, int index) {
                  final message = _messages[index];
                  return GestureDetector(
                    onLongPressStart: (_) {
                      _presentBottomSheet(message.messageId);
                    },
                    child: ChatMessageCell(
                      username: message.from,
                      message: message.text ?? '',
                      time: DateTime.fromMillisecondsSinceEpoch(
                          message.timestamp),
                      isSent:
                          message.sendingStatus == MessageSendingStatus.sent,
                      messageStatus: message.messageStatus?.status,
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Type your message here',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      _sendMessage(_textController.text);
                      _textController.clear();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessageCell extends StatelessWidget {
  final String username;
  final String message;
  final DateTime time;
  final bool isSent;
  final String? messageStatus;

  const ChatMessageCell({
    required this.message,
    required this.username,
    required this.time,
    required this.isSent,
    Key? key,
    required this.messageStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width / 2,
                  ),
                  child: Text(
                    username,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                isSent
                    ? Text(
                        message,
                        style: const TextStyle(fontSize: 16),
                      )
                    : Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Text(
                          message,
                          style: const TextStyle(fontSize: 16),
                        )),
                const SizedBox(height: 4),
                Text(
                  time.toString(),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                Visibility(
                  visible: messageStatus != null,
                  child: Text(
                    messageStatus ?? '',
                    textAlign: TextAlign.right,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
