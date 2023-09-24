import '../../ws/models/event.dart';
import '../db/drift_chat_database.dart';

/// Useful mapping functions for [ConnectionEventEntity]
extension ConnectionEventX on ConnectionEventEntity {
  /// Maps a [ConnectionEventEntity] into [Event]
  Event toEvent() => Event(type,
      createdAt: lastEventAt,
      totalUnreadCount: totalUnreadCount,
      unreadChannels: unreadChannels);
}
