import 'dart:typed_data';

import 'package:web3mq/native.dart';

///
abstract class MlsClient {
  Future<void> initialUser({required String userId});

  Future<String> registerUser({required String userId});

  Future<bool> isMlsGroup({required String userId, required String groupId});

  Future<String> createGroup({required String userId, required String groupId});

  Future<void> syncMlsState(
      {required String userId, required List<String> groupIds});

  Future<bool> canAddMemberToGroup(
      {required String userId, required String targetUserId});

  Future<void> addMemberToGroup(
      {required String userId,
      required String memberUserId,
      required String groupId});

  Future<String> mlsEncryptMsg(
      {required String userId, required String msg, required String groupId});

  Future<String> mlsDecryptMsg(
      {required String userId,
      required String msg,
      required String senderUserId,
      required String groupId});

  Future<void> handleMlsGroupEvent(
      {required String userId, required Uint8List msgBytes});
}

class MlsClientImpl implements MlsClient {
  @override
  Future<void> addMemberToGroup(
      {required String userId,
      required String memberUserId,
      required String groupId}) async {
    rust.addMemberToGroup(
        userId: userId, memberUserId: memberUserId, groupId: groupId);
  }

  @override
  Future<bool> canAddMemberToGroup(
      {required String userId, required String targetUserId}) async {
    return rust.canAddMemberToGroup(userId: userId, targetUserId: targetUserId);
  }

  @override
  Future<String> createGroup(
      {required String userId, required String groupId}) async {
    return rust.createGroup(userId: userId, groupId: groupId);
  }

  @override
  Future<void> handleMlsGroupEvent(
      {required String userId, required Uint8List msgBytes}) async {
    rust.handleMlsGroupEvent(userId: userId, msgBytes: msgBytes);
  }

  @override
  Future<void> initialUser({required String userId}) async {
    rust.initialUser(userId: userId);
  }

  @override
  Future<bool> isMlsGroup(
      {required String userId, required String groupId}) async {
    return rust.isMlsGroup(userId: userId, groupId: groupId);
  }

  @override
  Future<String> mlsDecryptMsg(
      {required String userId,
      required String msg,
      required String senderUserId,
      required String groupId}) {
    return rust.mlsDecryptMsg(
        userId: userId, msg: msg, senderUserId: senderUserId, groupId: groupId);
  }

  @override
  Future<String> mlsEncryptMsg(
      {required String userId, required String msg, required String groupId}) {
    return rust.mlsEncryptMsg(userId: userId, msg: msg, groupId: groupId);
  }

  @override
  Future<String> registerUser({required String userId}) {
    return rust.registerUser(userId: userId);
  }

  @override
  Future<void> syncMlsState(
      {required String userId, required List<String> groupIds}) {
    return rust.syncMlsState(userId: userId, groupIds: groupIds);
  }
}
