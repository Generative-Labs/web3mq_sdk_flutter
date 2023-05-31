import 'package:web3mq/src/ws/models/event.dart';

import '../api/responses.dart';
import '../models/channel_state.dart';
import '../models/pagination.dart';

/// A simple client used for persisting chat data locally.
abstract class PersistenceClient {
  /// Creates a new connection to the client
  Future<void> connect(String userId);

  /// Closes the client connection
  /// If [flush] is true, the data will also be deleted
  Future<void> disconnect({bool flush = false});

  /// Get stored connection event
  Future<Event?> getConnectionInfo();

  /// Get stored lastSyncAt
  Future<DateTime?> getLastSyncAt();

  /// Update stored connection event
  Future<void> updateConnectionInfo(Event event);

  /// Update stored lastSyncAt
  Future<void> updateLastSyncAt(DateTime lastSyncAt);

  /// Get the channel cids saved in the offline storage
  Future<List<String>> getChannelTopics();

  /// Get stored [ChannelModel]s by providing channel [topic]
  Future<ChannelModel?> getChannelByTopic(String topic);

  /// Get stored channel [Member]s by providing channel [topic]
  Future<List<Member>?> getMembersByTopic(String topic);

  /// Get stored [Message]s by providing channel [topic]
  ///
  /// Optionally, you can [messagePagination]
  /// for filtering out messages
  Future<List<Message>> getMessagesByTopic(
    String topic, {
    Pagination? messagePagination,
  });

  /// Get [ChannelState] data by providing channel [topic]
  Future<ChannelState?> getChannelStateByTopic(String topic,
      {Pagination? messagePagination}) async {
    final data = await Future.wait([
      getMembersByTopic(topic),
      getChannelByTopic(topic),
      getMessagesByTopic(topic, messagePagination: messagePagination),
    ]);
    final channel = data[1] as ChannelModel?;
    if (channel == null) return null;
    return ChannelState(
      members: data[0] as List<Member>?,
      channel: channel,
      messages: data[2] as List<Message>? ?? [],
    );
  }

  /// Get all the stored [ChannelState]s
  Future<List<ChannelState>> getChannelStates({
    Pagination? paginationParams,
  });

  /// Update list of channel queries.
  ///
  /// If [clearQueryCache] is true before the insert
  /// the list of matching rows will be deleted
  Future<void> updateChannelQueries(
    List<String> topics, {
    bool clearQueryCache = false,
  });

  /// Remove a message by [messageId]
  Future<void> deleteMessageById(String messageId) =>
      deleteMessageByIds([messageId]);

  /// Remove a message by [messageIds]
  Future<void> deleteMessageByIds(List<String> messageIds);

  /// Remove a message by channel [topic]
  Future<void> deleteMessageByTopic(String topic) =>
      deleteMessageByTopics([topic]);

  /// Remove a message by message [topics]
  Future<void> deleteMessageByTopics(List<String> topics);

  /// Remove a channel by [channelId]
  Future<void> deleteChannels(List<String> topics);

  Future<Message?> getMessageById(String messageId);

  /// Updates the message data of a particular channel [topic] with
  /// the new [messages] data
  Future<void> updateMessages(String topic, List<Message> messages) =>
      bulkUpdateMessages({topic: messages});

  /// Bulk updates the message data of multiple channels.
  Future<void> bulkUpdateMessages(Map<String, List<Message>?> messages);

  /// Returns all the threads by parent message of a particular channel by
  /// providing channel [topic]
  Future<Map<String, List<Message>>> getChannelThreads(String topic);

  /// Updates all the channels using the new [channels] data.
  Future<void> updateChannels(List<ChannelModel> channels);

  /// Updates all the messages to read
  Future<void> markAllToReadByTopic(String topic);

  /// Updates all the members of a particular channel [topic]
  /// with the new [members] data
  Future<void> updateMembers(String topic, List<Member> members) =>
      bulkUpdateMembers({topic: members});

  /// Bulk updates the members data of multiple channels.
  Future<void> bulkUpdateMembers(Map<String, List<Member>?> members);

  /// Updates the users data with the new [users] data
  Future<void> updateUsers(List<UserModel> users);

  /// Deletes all the members by channel [cids]
  Future<void> deleteMembersByTopics(List<String> topics);

  /// Update the channel state data using [channelState]
  Future<void> updateChannelState(ChannelState channelState) =>
      updateChannelStates([channelState]);

  /// Update list of channel states
  Future<void> updateChannelStates(List<ChannelState> channelStates) async {
    final membersToDelete = <String>[];

    final channels = <ChannelModel>[];
    final channelWithMessages = <String, List<Message>?>{};
    final channelWithMembers = <String, List<Member>?>{};

    for (final state in channelStates) {
      final channel = state.channel;
      channels.add(channel);

      final topic = channel.topic;
      final members = state.members;
      final Iterable<Message> messages = state.messages;

      // Preparing deletion data
      membersToDelete.add(topic);

      // preparing addition data
      channelWithMembers[topic] = members;
      channelWithMessages[topic] = messages.toList();
    }

    // Removing old members data as they may have
    // changes over the time.
    await Future.wait([
      deleteMembersByTopics(membersToDelete),
    ]);

    // Updating first as does not depend on any other table.
    await Future.wait([
      updateChannels(channels.toList(growable: false)),
    ]);

    // All has a foreign key relation with channels table.
    await Future.wait([
      bulkUpdateMembers(channelWithMembers),
      bulkUpdateMessages(channelWithMessages),
    ]);
  }
}
