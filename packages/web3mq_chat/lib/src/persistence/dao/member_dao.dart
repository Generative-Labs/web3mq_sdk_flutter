// coverage:ignore-file
import 'package:drift/drift.dart';
import 'package:web3mq/src/persistence/mapper/mapper.dart';

import '../../api/responses.dart';
import '../db/drift_chat_database.dart';
import '../entity/entity.dart';

part 'member_dao.g.dart';

/// The Data Access Object for operations in [Users] table.
@DriftAccessor(tables: [Members, Users])
class MemberDao extends DatabaseAccessor<DriftChatDatabase>
    with _$MemberDaoMixin {
  /// Creates a new user dao instance
  MemberDao(super.db);

  /// Get all members where [Members.channelTopic] matches [topic]
  Future<List<Member>> getMembersByTopic(String topic) async =>
      (select(members).join([
        leftOuterJoin(users, members.userId.equalsExp(users.id)),
      ])
            ..where(members.channelTopic.equals(topic))
            ..orderBy([OrderingTerm.asc(members.createdAt)]))
          .map((row) {
        final userEntity = row.readTable(users);
        final memberEntity = row.readTable(members);
        return memberEntity.toMember(user: userEntity.toUser());
      }).get();

  /// Updates all the members using the new [memberList] data
  Future<void> updateMembers(String topic, List<Member> memberList) =>
      bulkUpdateMembers({topic: memberList});

  /// Bulk updates the members data of multiple channels
  Future<void> bulkUpdateMembers(
    Map<String, List<Member>?> channelWithMembers,
  ) {
    final entities = channelWithMembers.entries
        .map((entry) =>
            (entry.value?.map(
              (member) => member.toEntity(topic: entry.key),
            )) ??
            [])
        .expand((it) => it)
        .toList(growable: false);
    return batch(
      (batch) => batch.insertAllOnConflictUpdate(members, entities),
    );
  }

  /// Deletes all the members whose [Members.channelCid] is present in [topics]
  Future<void> deleteMemberByTopics(List<String> topics) async => batch((it) {
        it.deleteWhere<Members, MemberEntity>(
          members,
          (m) => m.channelTopic.isIn(topics),
        );
      });
}
