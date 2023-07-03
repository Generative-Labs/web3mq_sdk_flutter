// coverage:ignore-file

import 'package:drift/drift.dart';

/// Represents a [Channels] table in [MoorChatDatabase].
@DataClassName('ChannelEntity')
class Channels extends Table {
  /// The id of this channel
  TextColumn get id => text()();

  /// The name of this channel
  TextColumn get name => text()();

  /// The topic of this channel
  TextColumn get topic => text()();

  /// The type of this channel
  TextColumn get topicType => text()();

  /// The avatar url of this channel
  TextColumn get avatarUrl => text().nullable()();

  /// The channel type of this channel
  TextColumn get channelType => text()();

  /// The date of the last message
  DateTimeColumn get lastMessageAt => dateTime().nullable()();

  /// The count of unread messages
  IntColumn get unreadMessageCount =>
      integer().withDefault(const Constant(0))();

  /// The date of channel deletion
  DateTimeColumn get deletedAt => dateTime().nullable()();

  /// The date of channel creation
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// The date of the last channel update
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
