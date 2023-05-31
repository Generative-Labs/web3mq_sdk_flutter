import 'package:flutter/material.dart';
import 'package:web3mq/web3mq.dart';

class TopicSelector extends StatefulWidget {
  final List<Topic> topics;

  final Function(String) onTopicSelected;

  const TopicSelector(
      {super.key, required this.topics, required this.onTopicSelected});

  @override
  State<StatefulWidget> createState() => _TopicSelectorState();
}

class _TopicSelectorState extends State<TopicSelector> {
  String? _selectedTopicId;

  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    _selectedTopicId = widget.topics.first.topicId;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Select Topic',
      ),
      value: _selectedTopicId,
      isExpanded: true,
      onChanged: (String? newValue) {
        setState(() {
          _selectedTopicId = newValue!;
          widget.onTopicSelected(newValue);
        });
      },
      items: widget.topics.map((Topic topic) {
        return DropdownMenuItem<String>(
          value: topic.topicId,
          child: Text(
            topic.topicId,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
    );
  }
}
