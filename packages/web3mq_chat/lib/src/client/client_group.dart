part of 'client.dart';

extension ClientGroup on Web3MQClient {
  /// Retrieves a paginated list of groups which you joined in.
  Future<Page<Group>> groups(
          {Pagination pagination =
              const Pagination(page: 1, size: 30)}) async =>
      await _service.group.groups(pagination: pagination);

  /// Creates a group and returns a Group object.
  ///
  /// [groupName] is the name of the group.
  /// [avatarUrl] is the URL of the group's avatar.
  /// [permissions] are the permissions of the group [GroupPermission]. Defaults to public.
  Future<Group> createGroup(String groupName, String? avatarUrl,
      {GroupPermission permissions = GroupPermission.public}) async {
    final group = await _service.group
        .createGroup(groupName, avatarUrl, permissions: permissions);

    await _mlsClient.createGroup(
        userId: state.currentUser!.userId, groupId: group.groupId);

    // if create group success, should refresh channel list.
    fetchChannelsFromServer();
    return group;
  }

  /// Retrieves a paginated list of group members by the specified group ID.
  Future<Page<Member>> membersByGroupId(String groupId,
          {Pagination pagination =
              const Pagination(page: 1, size: 30)}) async =>
      _service.group.membersByGroupId(groupId, pagination: pagination);

  /// Invites the specified users to the specified group.
  Future<void> invite(String groupId, List<String> userIds) async {
    final currentUserId = state.currentUser?.userId ?? "";
    // filter the targetUserId which `_mlsClient.canAddMemberToGroup` return false.
    final futures = userIds.map((userId) => _mlsClient.canAddMemberToGroup(
        userId: currentUserId, targetUserId: userId));
    final results = await Future.wait(futures);
    final filteredUserIds =
        userIds.where((userId) => results[userIds.indexOf(userId)]).toList();
    final result = await _service.group.invite(groupId, filteredUserIds);
    // if invite success, should add member to mls group.
    for (var userId in filteredUserIds) {
      await _mlsClient.addMemberToGroup(
          userId: currentUserId, memberUserId: userId, groupId: groupId);
    }
    return result;
  }

  /// Retrieves information for a specific group by its group ID.
  Future<Group> groupInfo(String groupId) async =>
      _service.group.groupInfo(groupId);

  /// Updates the group permissions for the specified group.
  Future<void> updateGroupPermissions(
          String groupId, GroupPermission permission) async =>
      _service.group.updateGroupPermissions(groupId, permission);

  /// Joins a group with the specified group ID.
  Future<void> joinGroup(String groupId) async {
    await _service.group.joinGroup(groupId);
    // if join group success, should refresh channel list.
    fetchChannelsFromServer();
  }

  @Deprecated("Use [leaveGroup] instead")
  Future<void> quitGroup(String groupId) async {
    await leaveGroup(groupId);
  }

  /// Quits a group with the specified group ID.
  Future<void> leaveGroup(String groupId) async {
    await _service.group.leaveGroup(groupId);
    // if quit group success, should refresh channel list.
    fetchChannelsFromServer();
  }
}
