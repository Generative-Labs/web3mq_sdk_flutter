import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:web3mq/web3mq.dart';

class ContactsListTile extends StatelessWidget {
  /// Creates a new instance of [ContactsListTile] widget.
  const ContactsListTile({
    super.key,
    required this.user,
    this.onTap,
    this.onLongPress,
    this.tileColor,
    this.selected = false,
    this.selectedTileColor,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 8),
  });

  /// The channel to display.
  final FollowUser user;

  /// Called when the user taps this list tile.
  final GestureTapCallback? onTap;

  /// Called when the user long-presses on this list tile.
  final GestureLongPressCallback? onLongPress;

  final EdgeInsetsGeometry contentPadding;

  /// Defines the background color of `ListTile`.
  ///
  /// When the value is null,
  /// the `tileColor` is set to [ListTileTheme.tileColor]
  /// if it's not null and to [Colors.transparent] if it's null.
  final Color? tileColor;

  /// True if the tile is in a selected state.
  final bool selected;

  /// The color of the tile in selected state.
  final Color? selectedTileColor;

  @override
  Widget build(BuildContext context) {
    final avatarUrl = user.avatarUrl;
    return ListTile(
      onTap: onTap,
      onLongPress: onLongPress,
      tileColor: tileColor,
      selected: selected,
      selectedTileColor: selectedTileColor,
      leading: avatarUrl != null
          ? CachedNetworkImage(
              imageUrl: avatarUrl,
              placeholder: (context, url) => const CircularProgressIndicator(),
              imageBuilder: (context, imageProvider) => CircleAvatar(
                    radius: 30,
                    backgroundImage: imageProvider,
                  ))
          : null,
      title: Text(user.userId),
      trailing: TextButton(
        onPressed: onTap,
        child: Text(_trailingButtonTextByFollowStatus(user.followStatus)),
      ),
      subtitle: Text(user.walletAddress ?? ''),
    );
  }

  String _trailingButtonTextByFollowStatus(String followStatus) {
    switch (followStatus) {
      case FollowStatus.followEach:
      case FollowStatus.following:
        return 'Unfollow';
      case FollowStatus.follower:
      case FollowStatus.empty:
      default:
        return 'Follow';
    }
  }
}
