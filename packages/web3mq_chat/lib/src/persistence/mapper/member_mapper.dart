import '../../api/responses.dart';
import '../db/drift_chat_database.dart';

/// Useful mapping functions for [MemberEntity]
extension MemberEntityX on MemberEntity {
  /// Maps a [MemberEntity] into [Member]
  Member toMember({UserModel? user}) =>
      Member(userId, user?.nickname, user?.avatarUrl,
          createdAt: createdAt, updatedAt: updatedAt);
}

/// Useful mapping functions for [Member]
extension MemberX on Member {
  /// Maps a [Member] into [MemberEntity]
  MemberEntity toEntity({required String topic}) => MemberEntity(
        userId: userId,
        channelTopic: topic,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
