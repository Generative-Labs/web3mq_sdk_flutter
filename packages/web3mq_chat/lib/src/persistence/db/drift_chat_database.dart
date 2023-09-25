import 'package:drift/drift.dart';
import 'package:web3mq_core/models.dart';

import '../converter/converter.dart';
import '../dao/dao.dart';
import '../entity/entity.dart';

part 'drift_chat_database.g.dart';

/// A chat database implemented using moor
@DriftDatabase(
  tables: [
    Channels,
    Messages,
    Users,
    Members,
    ChannelQueries,
    ConnectionEvents,
  ],
  daos: [
    UserDao,
    ChannelDao,
    MessageDao,
    MemberDao,
    ChannelQueryDao,
    ConnectionEventDao,
  ],
)
class DriftChatDatabase extends _$DriftChatDatabase {
  /// Creates a new moor chat database instance
  DriftChatDatabase(
    this._userId,
    QueryExecutor executor,
  ) : super(executor);

  /// Instantiate a new database instance
  DriftChatDatabase.connect(
    this._userId,
    DatabaseConnection connection,
  ) : super.connect(connection);

  final String _userId;

  /// User id to which the database is connected
  String get userId => _userId;

  // you should bump this number whenever you change or add a table definition.
  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
        onUpgrade: (openingDetails, before, after) async {
          if (before != after) {
            final m = createMigrator();
            for (final table in allTables) {
              await m.deleteTable(table.actualTableName);
              await m.createTable(table);
            }
          }
        },
      );

  /// Deletes all the tables
  Future<void> flush() => batch((batch) {
        for (final table in allTables) {
          delete(table).go();
        }
      });

  /// Closes the database instance
  Future<void> disconnect() => close();
}
