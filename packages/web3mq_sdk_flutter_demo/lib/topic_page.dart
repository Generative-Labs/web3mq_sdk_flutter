import 'package:flutter/material.dart';
import 'package:web3mq/web3mq.dart';
import 'package:web3mq_sdk_flutter_demo/topic_selector.dart';

import 'main.dart';

class TopicPage extends StatefulWidget {
  const TopicPage({super.key});

  @override
  State<StatefulWidget> createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  final _topicNameController = TextEditingController();

  final _titleController = TextEditingController();

  final _contentController = TextEditingController();

  List<Topic> _topics = [];

  @override
  void initState() {
    super.initState();
    if (!mounted) return;

    _loadSubscribeTopics();
  }

  Future<void> _loadSubscribeTopics() async {
    if (!mounted) {
      return;
    }
    final topics =
        await client.mySubscribeTopics(const Pagination(page: 1, size: 100));
    setState(() {
      _topics = topics;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Topic"),
        actions: [
          TextButton(
            onPressed: _onShowCreatingTopicDialog,
            child: const Text(
              "Create",
              style: TextStyle(color: Colors.white),
            ),
          ),
          // IconButton(onPressed: _showMyDialog, icon: const Icon(Icons.add))
          TextButton(
            onPressed: _onShowPublishMessageToTopicDialog,
            child: const Text(
              "Publish",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _loadSubscribeTopics();
          await Future.delayed(const Duration(seconds: 1));
        },
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _topics.length,
          itemBuilder: (context, index) {
            final item = _topics[index];
            return ListTile(
              title: Text(item.topicId),
              subtitle: Text(item.name),
            );
          },
        ),
      ),
    );
  }

  void _showSnackBar(String text) {
    final snackBar = SnackBar(
      key: UniqueKey(),
      content: Text(text),
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _createAndSubscribeTopic(String topicName) async {
    final topic = await client.createTopic(topicName);
    await client.subscribeTopic(topic.topicId);
    _showSnackBar("Create topic success!");
  }

  String? _selectTopicId;

  void _onPublishMessage(String title, String content, String topicId) async {
    try {
      await client.publish(title, content, topicId);
      _showSnackBar(
          "Publish success!, you can see notification on notification tab");
    } catch (e) {
      _showSnackBar(e.toString());
    }
  }

  Future<void> _onShowCreatingTopicDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          key: UniqueKey(),
          title: const Text('Create a topic'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('enter your topic name'),
                TextField(
                  controller: _topicNameController,
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
              child: const Text('Create'),
              onPressed: () {
                _createAndSubscribeTopic(_topicNameController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onShowPublishMessageToTopicDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          key: UniqueKey(),
          title: const Text('Publish message'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(hintText: 'title'),
                  controller: _titleController,
                ),
                TextField(
                  decoration: const InputDecoration(hintText: 'content'),
                  controller: _contentController,
                ),
                TopicSelector(
                  key: UniqueKey(),
                  topics: _topics,
                  onTopicSelected: (String topicId) {
                    _selectTopicId = topicId;
                  },
                )
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
              child: const Text('Create'),
              onPressed: () {
                if (null != _selectTopicId) {
                  _onPublishMessage(_titleController.text,
                      _contentController.text, _selectTopicId!);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
