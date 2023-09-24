import 'package:drift/drift.dart';
import 'package:web3mq/src/persistence/mapper/channel_mapper.dart';

import '../../api/responses.dart';
import '../db/drift_chat_database.dart';
import '../entity/entity.dart';

part 'channel_dao.g.dart';

/// The Data Access Object for operations in [Channels] table.
@DriftAccessor(tables: [Channels, Users])
class ChannelDao extends DatabaseAccessor<DriftChatDatabase>
    with _$ChannelDaoMixin {
  /// Creates a new channel dao instance
  ChannelDao(super.db);

  /// Get channel by topic
  Future<ChannelModel?> getChannelByTopic(String topic) async =>
      (select(channels)..where((c) => c.topic.equals(topic))).map((rows) {
        return rows.toChannelModel();
      }).getSingleOrNull();

  /// Delete all channels by matching topic in [topics]
  ///
  /// This will automatically delete the following linked records
  /// 1. Channel Reads
  /// 2. Channel Members
  /// 3. Channel Messages
  Future<int> deleteChannelByTopics(List<String> topics) async =>
      (delete(channels)..where((tbl) => tbl.topic.isIn(topics))).go();

  /// Get the channel topics saved in the storage
  Future<List<String>> get topics => (select(channels)
        ..orderBy([(c) => OrderingTerm.desc(c.lastMessageAt)])
        ..limit(250))
      .map((c) => c.topic)
      .get();

  /// Updates all the channels using the new [channelList] data
  Future<void> updateChannels(List<ChannelModel> channelList) => batch(
        (it) => it.insertAllOnConflictUpdate(
          channels,
          channelList.map((c) => c.toEntity()).toList(),
        ),
      );
}
