import 'package:drift/drift.dart';

import '../../models/message_sending_status.dart';

/// Maps a [MessageSendingStatus] into a [int] understood
/// by the sqlite backend.
class MessageSendingStatusConverter
    extends TypeConverter<MessageSendingStatus, int> {
  @override
  MessageSendingStatus? mapToDart(int? fromDb) {
    switch (fromDb) {
      case 0:
        return MessageSendingStatus.sending;
      case 1:
        return MessageSendingStatus.sent;
      case 2:
        return MessageSendingStatus.failed;
      default:
        return null;
    }
  }

  @override
  int? mapToSql(MessageSendingStatus? value) {
    switch (value) {
      case MessageSendingStatus.sending:
        return 0;
      case MessageSendingStatus.sent:
        return 1;
      case MessageSendingStatus.failed:
        return 2;
      default:
        return null;
    }
  }
}
