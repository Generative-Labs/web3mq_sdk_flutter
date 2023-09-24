import '../../api/responses.dart';
import '../db/drift_chat_database.dart';

/// Useful mapping functions for [MessageEntity]
extension MessageEntityX on MessageEntity {
  /// Maps a [MessageEntity] into [Message]
  Message toMessage({UserModel? user}) => Message(
        channelTopic,
        userId,
        cipherSuite,
        id,
        timestamp,
        MessageStatus(read ? 'read' : null, null),
        user,
        messageText,
        threadId,
        messageType,
        extraData,
        sendingStatus: status,
      );
}

/// Useful mapping functions for [Message]
extension MessageX on Message {
  /// Maps a [Message] into [MessageEntity]
  MessageEntity toEntity() => MessageEntity(
      id: messageId,
      messageText: text,
      status: sendingStatus,
      messageType: messageType,
      timestamp: timestamp,
      createdAt: createdAt,
      updatedAt: updatedAt,
      userId: from,
      channelTopic: topic,
      cipherSuite: cipherSuite,
      threadId: threadId,
      read: messageStatus?.status == 'read',
      extraData: extraData);
}
