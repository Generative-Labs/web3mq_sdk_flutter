part of 'client.dart';

enum CyberFollowOperation {
  follow,
  unfollow;

  String get value {
    switch (this) {
      case follow:
        return 'FOLLOW';
      case unfollow:
        return 'UNFOLLOW';
    }
  }
}

extension ContactsExtension on Web3MQClient {
  /// Get user followings
  Future<Page<FollowUser>> followings(Pagination pagination) async {
    final users = await _service.contacts.followings(pagination);
    return _addCyberFollowStatusIfNeeded(users);
  }

  /// Get user followers
  Future<Page<FollowUser>> followers(Pagination pagination) async {
    final users = await _service.contacts.followers(pagination);
    return _addCyberFollowStatusIfNeeded(users);
  }

  /// Follows user
  Future<void> follow(String userId, String? message) async {
    await _doFollow(FollowAction.follow, userId, message);
  }

  /// Unfollow user
  Future<void> unfollow(String userId) async =>
      _doFollow(FollowAction.unfollow, userId, null);

  /// Follows cyber profile
  Future<String> cyberFollow(String targetAddress) async =>
      _doCyberFollow(CyberFollowOperation.follow, targetAddress);

  /// Unfollows cyber profile
  Future<String> cyberUnFollow(String targetAddress) async =>
      _doCyberFollow(CyberFollowOperation.unfollow, targetAddress);

  Future<String> _doCyberFollow(
      CyberFollowOperation operation, String targetAddress) async {
    if (null == _cyberService) {
      throw Web3MQContactsError.syncCyberDisabled;
    }
    if (null == walletConnector) {
      throw Web3MQContactsError.walletConnectorNotSet;
    }

    final user =
        await _cyberService!.profile.getProfileByAddress(targetAddress);

    if (null == user || user.handle.isEmpty) {
      throw Web3MQContactsError.cyberUserNotFound;
    }

    final signingKey = await registerCyberSigningKey();

    final address = state.currentUser?.did.value ?? '';
    final handle = user.handle;
    final message = await _cyberService!.connection
        .followGetMessage(operation.value, address, handle);

    final signature = await walletConnector!.personalSign(message, address);
    return await _cyberService!.connection
        .follow(address, user.handle, signature, signingKey);
  }

  Future<void> _doFollow(
      FollowAction action, String targetUserId, String? message) async {
    final walletConnector = this.walletConnector;
    if (walletConnector == null) {
      throw Web3MQContactsError.walletConnectorNotSet;
    }
    final walletInfo = await walletConnector.connectWallet();
    final account = Account.from(walletInfo.accounts.first);
    final walletType = CAIP10Helper.walletType(account);
    final walletAddress = account.address;

    // current user info
    final user = await userInfo(walletType, walletAddress);

    final userId = user?.userId;
    if (userId == null) {
      throw Web3MQContactsError.userNotExist();
    }

    final walletTypeName = CAIP10Helper.walletTypeDescription(account);

    final currentDate = DateTime.now();
    final timestamp = currentDate.millisecondsSinceEpoch;

    final nonceContentRaw = '$userId$action$targetUserId$timestamp';
    final sha224 = pointycastle.Digest("SHA3-224");

    final nonceContentHash =
        sha224.process(Uint8List.fromList(utf8.encode(nonceContentRaw)));
    final nonceContent = hex.encode(nonceContentHash);

    final dateFormatter = DateFormat('dd/MM/yyyy HH:mm');
    final formattedDateString = dateFormatter.format(currentDate);

    final signatureRaw =
        '''
Web3MQ wants you to sign in with your $walletTypeName account:
$walletAddress

For follow signature

Nonce: $nonceContent
Issued At: $formattedDateString`''';

    final signature =
        await walletConnector.personalSign(signatureRaw, walletAddress);

    switch (action) {
      case FollowAction.follow:
        _follow(targetUserId, walletType, user?.pubKey, message, signatureRaw,
            signature);
        break;
      case FollowAction.unfollow:
        _unfollow(
            targetUserId, walletType, user?.pubKey, signatureRaw, signature);
        break;
    }
  }

  /// Follows user
  Future<void> _follow(
    String targetUserId,
    String didType,
    String? didPublicKey,
    String? message,
    String signContent,
    String signature,
  ) async =>
      _service.contacts.follow(
          targetUserId, didType, didPublicKey, message, signContent, signature);

  /// Follows user
  Future<void> _unfollow(
    String targetUserId,
    String didType,
    String? didPublicKey,
    String signContent,
    String signature,
  ) async =>
      _service.contacts.unfollow(
          targetUserId, didType, didPublicKey, signContent, signature);

  Future<Page<FollowUser>> _addCyberFollowStatusIfNeeded(
      Page<FollowUser> users) async {
    if (null != _cyberService) {
      await _authCyberIfNeeded();
      final addresses =
          users.result.map((e) => e.walletAddress).whereType<String>().toList();
      final me = state.currentUser?.did.value;
      final cyberStatuses = await _cyberService!.connection
          .batchAddressesFollowStatus(me ?? '', addresses);
      users.result = _mergeCyberStatusWithUsers(users.result, cyberStatuses);
    }
    return users;
  }

  List<FollowUser> _mergeCyberStatusWithUsers(
      List<FollowUser> users, List<CyberFollowStatus> cyberStatusList) {
    // 将 cyberStatusList 转换为基于 walletAddress 的 Map
    final cyberStatusMap = {
      for (var status in cyberStatusList) status.address: status
    };
    // 使用 map() 函数将每个用户与其相应的 cyberStatus 进行合并
    return users.map((user) {
      final userAddress = user.walletAddress;
      if (userAddress != null && cyberStatusMap.containsKey(userAddress)) {
        user.cyberStatus = cyberStatusMap[userAddress];
      }
      return user;
    }).toList();
  }
}
