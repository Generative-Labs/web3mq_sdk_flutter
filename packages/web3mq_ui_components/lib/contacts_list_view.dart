import 'package:flutter/material.dart';
import 'package:web3mq/web3mq.dart';
import 'package:web3mq_ui_components/contacts_list_tile.dart';

///
class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key, required this.client});

  final Web3MQClient client;

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
    _refreshFollowers();
    _refreshFollowings();
  }

  Future<void> _refreshFollowings() async {
    final page =
        await widget.client.followers(const Pagination(page: 1, size: 50));
    if (mounted) {
      setState(() {
        followers = page.result;
      });
    }
  }

  Future<void> _refreshFollowers() async {
    final page =
        await widget.client.followings(const Pagination(page: 1, size: 50));
    if (mounted) {
      setState(() {
        followings = page.result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        bottom: TabBar(controller: _tabController, tabs: contactsTabs),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          RefreshIndicator(
            onRefresh: _refreshFollowings,
            child: ListView.separated(
                itemBuilder: (context, index) {
                  final user = followings[index];
                  return ContactsListTile(
                    user: user,
                    onTap: () {
                      widget.client.unfollow(user.userId).then((value) {
                        _loadDatas();
                      });
                    },
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: followings.length),
          ),
          RefreshIndicator(
            onRefresh: _refreshFollowers,
            child: ListView.separated(
                itemBuilder: (context, index) {
                  final user = followers[index];
                  return ContactsListTile(
                    user: user,
                    onTap: () {
                      widget.client.follow(user.userId, null).then((value) {
                        _loadDatas();
                      });
                    },
                  );
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
