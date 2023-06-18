enum NotificationType {
  all(value: ""),
  subscription(value: "subscription"),
  receivedFriendRequest(value: "system.friend_request"),
  sendFriendRequest(value: "system.agree_friend_request"),
  groupInvitation(value: "group_invitation"),
  provider(value: "provider.notification");

  const NotificationType({
    required this.value,
  });

  final String value;
}

enum ReadStatus {
  received,
  delivered,
  read,
}

enum GroupPermission {
  invite,
  public,
  nftValidation;

  String get value {
    switch (this) {
      case GroupPermission.invite:
        return 'ceator_invite_friends';
      case GroupPermission.public:
        return 'public';
      case GroupPermission.nftValidation:
        return 'nft_validation';
    }
  }
}
