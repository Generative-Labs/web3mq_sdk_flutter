import 'package:web3mq/src/api/responses.dart';

import '../db/drift_chat_database.dart';

/// Useful mapping functions for [ChannelEntity]
extension ChannelEntityX on ChannelEntity {
  /// Maps a [ChannelEntity] into [ChannelModel]
  ChannelModel toChannelModel() {
    return ChannelModel(topic, topicType, id, channelType, name, avatarUrl,
        lastMessageAt, deletedAt,
        unreadMessageCount: unreadMessageCount,
        createdAt: createdAt,
        updatedAt: updatedAt);
  }
}

/// Useful mapping functions for [ChannelModel]
extension ChannelModelX on ChannelModel {
  /// Maps a [ChannelModel] into [ChannelEntity]
  ChannelEntity toEntity() => ChannelEntity(
      id: channelId,
      name: name,
      topic: topic,
      topicType: topicType,
      avatarUrl: avatarUrl,
      channelType: channelType,
      lastMessageAt: lastMessageAt,
      deletedAt: deletedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
      unreadMessageCount: unreadMessageCount);
}
