// coverage:ignore-file

import 'package:drift/drift.dart';

/// Represents a [Users] table in [MoorChatDatabase].
@DataClassName('UserEntity')
class Users extends Table {
  /// User id
  TextColumn get id => text()();

  /// The nickname of this user
  TextColumn get nickname => text().nullable()();

  /// The avatar url of this user
  TextColumn get avatarUrl => text().nullable()();

  /// Date of user creation
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Date of last user update
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
