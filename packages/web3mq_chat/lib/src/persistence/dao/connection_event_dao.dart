import 'package:drift/drift.dart';
import 'package:web3mq/src/persistence/entity/connection_events.dart';
import 'package:web3mq/src/persistence/mapper/event_mapper.dart';
import 'package:web3mq_websocket/web3mq_websocket.dart';

import '../db/drift_chat_database.dart';

part 'connection_event_dao.g.dart';

/// The Data Access Object for operations in [ConnectionEvents] table.
@DriftAccessor(tables: [ConnectionEvents])
class ConnectionEventDao extends DatabaseAccessor<DriftChatDatabase>
    with _$ConnectionEventDaoMixin {
  /// Creates a new connection event dao instance
  ConnectionEventDao(super.db);

  /// Get the latest stored connection event
  Future<Event?> get connectionEvent => select(connectionEvents)
      .map((eventEntity) => eventEntity.toEvent())
      .getSingleOrNull();

  /// Get the latest stored lastSyncAt
  Future<DateTime?> get lastSyncAt =>
      select(connectionEvents).getSingleOrNull().then((r) => r?.lastSyncAt);

  /// Update stored connection event with latest data
  Future<int> updateConnectionEvent(Event event) => transaction(() async {
        final connectionInfo = await select(connectionEvents).getSingleOrNull();
        return into(connectionEvents).insertOnConflictUpdate(
          ConnectionEventEntity(
            id: 1,
            type: event.type,
            lastSyncAt: connectionInfo?.lastSyncAt,
            lastEventAt: event.createdAt,
            totalUnreadCount:
                event.totalUnreadCount ?? connectionInfo?.totalUnreadCount,
            ownUser: connectionInfo?.ownUser,
            unreadChannels:
                event.unreadChannels ?? connectionInfo?.unreadChannels,
          ),
        );
      });

  /// Update stored lastSyncAt with latest data
  Future<int> updateLastSyncAt(DateTime lastSyncAt) async =>
      (update(connectionEvents)..where((tbl) => tbl.id.equals(1))).write(
        ConnectionEventsCompanion(
          lastSyncAt: Value(lastSyncAt),
        ),
      );
}
