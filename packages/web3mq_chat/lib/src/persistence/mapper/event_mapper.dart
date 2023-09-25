import 'package:web3mq_websocket/web3mq_websocket.dart';

import '../db/drift_chat_database.dart';

/// Useful mapping functions for [ConnectionEventEntity]
extension ConnectionEventX on ConnectionEventEntity {
  /// Maps a [ConnectionEventEntity] into [Event]
  Event toEvent() => Event(type,
      createdAt: lastEventAt,
      totalUnreadCount: totalUnreadCount,
      unreadChannels: unreadChannels);
}
