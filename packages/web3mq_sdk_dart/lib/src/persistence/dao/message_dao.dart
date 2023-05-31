import 'package:drift/drift.dart';
import 'package:web3mq/src/persistence/mapper/mapper.dart';

import '../../api/responses.dart';
import '../../models/pagination.dart';
import '../db/drift_chat_database.dart';
import '../entity/entity.dart';

part 'message_dao.g.dart';

/// The Data Access Object for operations in [Messages] table.
@DriftAccessor(tables: [Messages, Users])
class MessageDao extends DatabaseAccessor<DriftChatDatabase>
    with _$MessageDaoMixin {
  /// Creates a new message dao instance
  MessageDao(this._db) : super(_db);

  // ignore: unused_field
  final DriftChatDatabase _db;

  $UsersTable get _users => alias(users, 'users');

  /// Removes all the messages by matching [Messages.id] in [messageIds]
  ///
  /// This will automatically delete the following linked records
  /// 1. Message Reactions
  Future<int> deleteMessageByIds(List<String> messageIds) =>
      (delete(messages)..where((tbl) => tbl.id.isIn(messageIds))).go();

  /// Removes all the messages by matching [Messages.channelTopic] in [topics]
  ///
  /// This will automatically delete the following linked records
  /// 1. Message Reactions
  Future<void> deleteMessageByTopics(List<String> topics) async =>
      (delete(messages)..where((tbl) => tbl.channelTopic.isIn(topics))).go();

  Future<Message> _messageFromJoinRow(TypedResult rows) async {
    final userEntity = rows.readTableOrNull(_users);
    final msgEntity = rows.readTable(messages);
    return msgEntity.toMessage(
      user: userEntity?.toUser(),
    );
  }

  /// Returns a single message by matching the [Messages.id] with [id]
  Future<Message?> getMessageById(String id) async =>
      await (select(messages).join([
        leftOuterJoin(_users, messages.userId.equalsExp(_users.id)),
      ])
            ..where(messages.id.equals(id)))
          .map(_messageFromJoinRow)
          .getSingleOrNull();

  /// Returns all the messages of a particular thread by matching
  /// [Messages.channelTopic] with [topic]
  Future<List<Message>> getThreadMessages(String topic) async =>
      Future.wait(await (select(messages).join([
        leftOuterJoin(_users, messages.userId.equalsExp(_users.id)),
      ])
            ..where(messages.channelTopic.equals(topic))
            ..where(messages.threadId.isNotNull())
            ..orderBy([OrderingTerm.asc(messages.createdAt)]))
          .map(_messageFromJoinRow)
          .get());

  /// Returns all the messages of a particular thread by matching
  /// [Messages.threadId] with [parentId]
  Future<List<Message>> getThreadMessagesByParentId(
    String parentId, {
    Pagination? options,
  }) async {
    final msgList = await Future.wait(await (select(messages).join([
      leftOuterJoin(_users, messages.userId.equalsExp(_users.id)),
    ])
          ..where(messages.threadId.isNotNull())
          ..where(messages.threadId.equals(parentId))
          ..orderBy([OrderingTerm.asc(messages.createdAt)]))
        .map(_messageFromJoinRow)
        .get());
    return msgList;
  }

  /// Returns all the messages of a channel by matching
  /// [Messages.channelTopic] with [parentId]
  Future<List<Message>> getMessagesByTopic(
    String topic, {
    Pagination? messagePagination,
  }) async {
    final msgList = await Future.wait(await (select(messages).join([
      leftOuterJoin(_users, messages.userId.equalsExp(_users.id)),
    ])
          ..where(messages.channelTopic.equals(topic))
          ..where(
            messages.threadId.isNull() |
                messages.threadId.equals('') |
                messages.showInChannel.equals(true),
          )
          ..orderBy([OrderingTerm.asc(messages.timestamp)]))
        .map(_messageFromJoinRow)
        .get());
    return msgList;
  }

  /// Updates the message data of a particular channel with
  /// the new [messageList] data
  Future<void> updateMessages(String topic, List<Message> messageList) =>
      bulkUpdateMessages({topic: messageList});

  /// Bulk updates the message data of multiple channels
  Future<void> bulkUpdateMessages(
    Map<String, List<Message>?> channelWithMessages,
  ) {
    final entities = channelWithMessages.entries
        .map((entry) =>
            entry.value?.map(
              (message) => message.toEntity(),
            ) ??
            [])
        .expand((it) => it)
        .toList(growable: false);
    return batch(
      (batch) => batch.insertAllOnConflictUpdate(messages, entities),
    );
  }

  Future<void> updateAllToReadByTopic(String topic) async {
    await (update(messages)
          ..where((message) => message.channelTopic.equals(topic)))
        .write(MessagesCompanion(read: const Value(true)));
  }
}
