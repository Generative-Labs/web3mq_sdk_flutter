// coverage:ignore-file
import 'package:drift/drift.dart';

import '../converter/converter.dart';

/// Represents a [Messages] table in [MoorChatDatabase].
@DataClassName('MessageEntity')
class Messages extends Table {
  /// The message id
  TextColumn get id => text()();

  /// The text of this message
  TextColumn get messageText => text().nullable()();

  /// The status of a sending message
  IntColumn get status => integer()
      .withDefault(const Constant(1))
      .map(MessageSendingStatusConverter())();

  /// The read status of this message
  BoolColumn get read => boolean().withDefault(const Constant(false))();

  /// The message type
  TextColumn get messageType => text().nullable()();

  /// The ID of the parent message, if the message is a thread reply.
  TextColumn get threadId => text().nullable()();

  /// Check if this message needs to show in the channel.
  BoolColumn get showInChannel => boolean().nullable()();

  /// The timestamp of this message
  IntColumn get timestamp => integer()();

  /// The DateTime when the message was created.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// The DateTime when the message was updated last time.
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  /// The DateTime when the message was deleted.
  DateTimeColumn get deletedAt => dateTime().nullable()();

  /// Id of the User who sent the message
  TextColumn get userId => text()();

  /// The channel topic of which this message is part of
  TextColumn get channelTopic =>
      text().customConstraint('REFERENCES channels(topic) ON DELETE CASCADE')();

  /// The cipher suite of this message
  TextColumn get cipherSuite => text()();

  /// Message custom extraData
  TextColumn get extraData => text().nullable().map(MapConverter<String>())();

  @override
  Set<Column> get primaryKey => {id};
}
