import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:web3mq/web3mq.dart';
import 'package:intl/intl.dart';

/// A widget that displays a chat preview.
/// It shows the last message of the channel, the last message time, the unread
/// message count, avatar.
class ChatsListTile extends StatelessWidget {
  /// Creates a new instance of [ChatsListTile] widget.
  const ChatsListTile({
    super.key,
    required this.channelState,
    this.onTap,
    this.onLongPress,
    this.tileColor,
    this.selected = false,
    this.selectedTileColor,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 8),
  });

  /// The channel to display.
  final ChannelState channelState;

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
    final avatarUrl = channelState.channel.avatarUrl;
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
      title: Text(channelState.channel.name),
      trailing: _ChatLastMessageDate(channel: channelState.channel),
      subtitle: Row(
        children: [Text(channelState.lastMessage?.text ?? '')],
      ),
    );
  }
}

///
class _ChatLastMessageDate extends StatelessWidget {
  /// The channel to display the last message date for.
  final ChannelModel channel;

  const _ChatLastMessageDate({required this.channel});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final date = channel.lastMessageAt ?? now;
    final difference = now.difference(date).inDays;
    if (difference == 0) {
      final time = DateFormat('HH:mm').format(date);
      return Text(time);
    } else if (difference == 1) {
      final time = DateFormat('yesterday HH:mm').format(date);
      return Text(time);
    } else if (difference < 7) {
      final weekday = DateFormat('EEEE').format(date);
      final time = DateFormat('HH:mm').format(date);
      return Text('$weekday $time');
    } else {
      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      return Text(dateStr);
    }
  }
}
