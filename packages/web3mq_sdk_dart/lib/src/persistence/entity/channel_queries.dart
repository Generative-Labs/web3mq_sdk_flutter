import 'package:drift/drift.dart';

/// Represents a [ChannelQueries] table in [MoorChatDatabase].
@DataClassName('ChannelQueryEntity')
class ChannelQueries extends Table {
  /// The unique hash of this query
  TextColumn get queryHash => text()();

  /// The channel cid of this query
  TextColumn get channelTopic => text()();

  @override
  Set<Column> get primaryKey => {
        queryHash,
        channelTopic,
      };
}
