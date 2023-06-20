import 'package:flutter/material.dart';
import 'package:web3mq/web3mq.dart';

import 'main.dart';

///
class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<StatefulWidget> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<FollowUser> followings = [];
  List<FollowUser> followers = [];

  static const List<Tab> contactsTabs = [
    Tab(text: 'Followings'),
    Tab(text: 'Followers'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadDatas();
  }

  void _loadDatas() {
    _loadFollowers();
    _loadFollowings();
  }

  Future<void> _loadFollowings() async {
    final page = await client.followers(const Pagination(page: 1, size: 50));
    if (mounted) {
      setState(() {
        followers = page.result;
      });
    }
  }

  Future<void> _loadFollowers() async {
    final page = await client.followings(const Pagination(page: 1, size: 50));
    if (mounted) {
      setState(() {
        followings = page.result;
      });
    }
  }

  void _onTapFloatingButton() {
    _onFollowPeopleDialog();
  }

  void _onFollowPeople() {
    final userId = _userIdController.text;
    final message = _messageController.text;
    if (userId.isEmpty) {
      return;
    }
    client.follow(userId, message).then((value) {
      _loadDatas();
    });
  }

  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  void _onFollowPeopleDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          key: UniqueKey(),
          title: const Text('Follow'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(hintText: 'user id'),
                  controller: _userIdController,
                ),
                TextField(
                  decoration:
                      const InputDecoration(hintText: 'message(optional)'),
                  controller: _messageController,
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
              child: const Text('Follow'),
              onPressed: () {
                // follows
                _onFollowPeople();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        bottom: TabBar(controller: _tabController, tabs: contactsTabs),
        actions: [
          TextButton(
            onPressed: _onTapFloatingButton,
            child: const Text(
              "Follow",
              style: TextStyle(color: Colors.white),
            ),
          ),
          // IconButton(onPressed: _showMyDialog, icon: const Icon(Icons.add))
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          RefreshIndicator(
            onRefresh: _loadFollowings,
            child: ListView.separated(
                itemBuilder: (context, index) {
                  final user = followings[index];
                  return ListTile(
                      title: Text(user.userId),
                      subtitle: Text(user.followStatus),
                      trailing: TextButton(
                        child: const Text('Unfollow'),
                        onPressed: () {
                          client.unfollow(user.userId).then((value) {
                            _loadDatas();
                          });
                        },
                      ));
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: followings.length),
          ),
          RefreshIndicator(
            onRefresh: _loadFollowers,
            child: ListView.separated(
                itemBuilder: (context, index) {
                  final user = followers[index];
                  return ListTile(
                      title: Text(user.userId),
                      subtitle: Text(user.followStatus),
                      trailing: TextButton(
                        child: const Text('Follow'),
                        onPressed: () {
                          client.follow(user.userId, null).then((value) {
                            _loadDatas();
                          });
                        },
                      ));
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: followers.length),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
