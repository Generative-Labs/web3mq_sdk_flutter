part of 'client.dart';

///
extension ContactsExtension on Web3MQClient {
  /// Get user followings
  Future<Page<FollowUser>> followings(Pagination pagination) async {
    return await _service.contacts.followings(pagination);
  }

  /// Get user followers
  Future<Page<FollowUser>> followers(Pagination pagination) async {
    return await _service.contacts.followers(pagination);
  }

  /// Follows user
  Future<void> follow(String userId, String? message) async {
    await _doFollow(FollowAction.follow, userId, message);
    if (null != _extraServices) {
      for (var element in _extraServices!) {
        await element.follow(userId);
      }
    }
  }

  /// Unfollow user
  Future<void> unfollow(String userId) async {
    _doFollow(FollowAction.unfollow, userId, null);
    if (null != _extraServices) {
      for (var element in _extraServices!) {
        await element.unfollow(userId);
      }
    }
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
}
