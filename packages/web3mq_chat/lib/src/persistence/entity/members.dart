// coverage:ignore-file

import 'package:drift/drift.dart';

import 'channels.dart';

/// Represents a [Members] table in [MoorChatDatabase].
@DataClassName('MemberEntity')
class Members extends Table {
  /// The interested user id
  TextColumn get userId => text()();

  /// The channel topic of which this user is part of
  TextColumn get channelTopic =>
      text().references(Channels, #topic, onDelete: KeyAction.cascade)();

  /// The date of creation
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// The last date of update
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {userId, channelTopic};
}
