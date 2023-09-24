// part 'own_user.g.dart';
//
// @JsonSerializable(createToJson: false)
// class OwnUser extends User {
//   /// Total unread messages by the user.
//   @JsonKey(includeIfNull: false)
//   final int totalUnreadCount;
//
//   /// Total unread channels by the user.
//   @JsonKey(includeIfNull: false)
//   final int unreadChannels;
//
//   OwnUser(
//       {this.totalUnreadCount = 0,
//       this.unreadChannels = 0,
//         super.userId,
//
//
//       // required String userId,
//       // required DID did,
//       // required String privateKeyHex})
//       // : super(userId, did, privateKeyHex);
//
//   /// Constructor used for json serialization.
//
//   // OwnUser({
//   //   this.totalUnreadCount = 0,
//   //   this.unreadChannels = 0,
//   //   super.userId,
//   //   super.nickname,
//   //   super.avatarUrl,
//   //   super.createdAt,
//   //   super.updatedAt,
//   // });
//
//   /// Create a new instance from json.
//   factory OwnUser.fromJson(Map<String, dynamic> json) =>
//       _$OwnUserFromJson(json);
//
//   /// Create a new instance from [User] object.
//   factory OwnUser.fromUser(UserModel user) => OwnUser(
//         userId: user.userId,
//         nickname: user.nickname,
//         avatarUrl: user.avatarUrl,
//         createdAt: user.createdAt,
//         updatedAt: user.updatedAt,
//       );
//
//   OwnUser copyWith({
//     String? userId,
//     String? nickname,
//     String? avatarUrl,
//     DateTime? createdAt,
//     DateTime? updatedAt,
//     int? totalUnreadCount,
//     int? unreadChannels,
//   }) =>
//       OwnUser(
//         userId: userId ?? this.userId,
//         nickname: nickname ?? this.nickname,
//         avatarUrl: avatarUrl ?? this.avatarUrl,
//         createdAt: createdAt ?? this.createdAt,
//         updatedAt: updatedAt ?? this.updatedAt,
//         totalUnreadCount: totalUnreadCount ?? this.totalUnreadCount,
//         unreadChannels: unreadChannels ?? this.unreadChannels,
//       );
//
//   /// Returns a new [OwnUser] that is a combination of this ownUser
//   /// and the given [other] ownUser.
//   OwnUser merge(OwnUser? other) {
//     if (other == null) return this;
//     return copyWith(
//         userId: other.userId,
//         nickname: other.nickname,
//         avatarUrl: other.avatarUrl,
//         createdAt: other.createdAt,
//         updatedAt: other.updatedAt,
//         totalUnreadCount: other.totalUnreadCount,
//         unreadChannels: other.unreadChannels);
//   }
//
// // /// Known top level fields.
// // ///
// // /// Useful for [Serializer] methods.
// // static final topLevelFields = [
// //   'total_unread_count',
// //   'unread_channels',
// //   ...UserModel.topLevelFields,
// // ];
// }
