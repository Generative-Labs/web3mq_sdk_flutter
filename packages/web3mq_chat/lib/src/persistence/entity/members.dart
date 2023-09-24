// coverage:ignore-file

import 'package:drift/drift.dart';

/// Represents a [Members] table in [MoorChatDatabase].
@DataClassName('MemberEntity')
class Members extends Table {
  /// The interested user id
  TextColumn get userId => text()();

  /// The channel topic of which this user is part of
  TextColumn get channelTopic =>
      text().customConstraint('REFERENCES channels(topic) ON DELETE CASCADE')();

  /// The date of creation
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// The last date of update
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {userId, channelTopic};
}
