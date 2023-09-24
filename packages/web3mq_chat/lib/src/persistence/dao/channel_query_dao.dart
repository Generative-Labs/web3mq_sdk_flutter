import 'package:drift/drift.dart';
import 'package:web3mq/src/persistence/mapper/channel_mapper.dart';

import '../../api/responses.dart';
import '../../models/pagination.dart';
import '../db/drift_chat_database.dart';
import '../entity/entity.dart';

part 'channel_query_dao.g.dart';

/// The Data Access Object for operations in [ChannelQueries] table.
@DriftAccessor(tables: [ChannelQueries, Channels, Users])
class ChannelQueryDao extends DatabaseAccessor<DriftChatDatabase>
    with _$ChannelQueryDaoMixin {
  /// Creates a new channel query dao instance
  ChannelQueryDao(super.db);

  String _computeHash() {
    return 'allchannels';
  }

  /// Update list of channel queries
  /// If [clearQueryCache] is true before the insert
  /// the list of matching rows will be deleted
  Future<void> updateChannelQueries(
    List<String> topics, {
    bool clearQueryCache = false,
  }) async =>
      transaction(() async {
        final hash = _computeHash();
        if (clearQueryCache) {
          await batch((it) {
            it.deleteWhere<ChannelQueries, ChannelQueryEntity>(
              channelQueries,
              (c) => c.queryHash.equals(hash),
            );
          });
        }

        await batch((it) {
          it.insertAllOnConflictUpdate(
            channelQueries,
            topics
                .map((topic) =>
                    ChannelQueryEntity(queryHash: hash, channelTopic: topic))
                .toList(),
          );
        });
      });

  ///
  Future<List<String>> getCachedChannelTopics() {
    final hash = _computeHash();
    return (select(channelQueries)..where((c) => c.queryHash.equals(hash)))
        .map((c) => c.channelTopic)
        .get();
  }

  /// Get list of channels by filter, sort and paginationParams
  Future<List<ChannelModel>> getChannels({
    Pagination? paginationParams,
  }) async {
    final cachedChannelTopics = await getCachedChannelTopics();
    final query = select(channels)
      ..where((c) => c.topic.isIn(cachedChannelTopics));

    final cachedChannels = await query.map((rows) {
      return rows.toChannelModel();
    }).get();

    chainedComparator(ChannelModel a, ChannelModel b) {
      final dateA = a.lastMessageAt ?? a.createdAt;
      final dateB = b.lastMessageAt ?? b.createdAt;
      return dateB.compareTo(dateA);
    }

    cachedChannels.sort(chainedComparator);

    if (null != paginationParams) {
      int startIndex =
          ((paginationParams.page ?? 1) - 1) * paginationParams.size;
      int endIndex = (paginationParams.page ?? 1) * paginationParams.size;
      List selectedChannels = cachedChannels.sublist(startIndex, endIndex);
      return selectedChannels as List<ChannelModel>;
    }

    return cachedChannels;
  }
}
