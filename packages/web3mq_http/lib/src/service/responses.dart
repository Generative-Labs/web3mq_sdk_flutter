import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:web3mq_core/models.dart';

import '../serializer.dart';

part 'responses.g.dart';

DateTime _dateTimeFromJson(int value) =>
    DateTime.fromMillisecondsSinceEpoch(value);

///
@JsonSerializable(genericArgumentFactories: true, createToJson: false)
class Web3MQResponse<T> {
  /// The web3mq status code
  final int code;

  /// The message associated to the code
  @JsonKey(name: "msg")
  final String? message;

  ///
  late T? data;

  Web3MQResponse(this.code, this.message, this.data);

  factory Web3MQResponse.fromJson(
          Map<String, dynamic> json, T Function(dynamic json) fromJsonT) =>
      _$Web3MQResponseFromJson<T>(json, fromJsonT);
}

@JsonSerializable(genericArgumentFactories: true, createToJson: false)
class Page<T> {
  ///
  @JsonKey(name: "total_count", defaultValue: 0)
  int total = 0;

  ///
  @JsonKey(name: "data_list", defaultValue: [])
  List<T> result = [];

  Page(this.total, this.result);

  factory Page.fromJson(
          Map<String, dynamic> json, T Function(dynamic json) fromJsonT) =>
      _$PageFromJson<T>(json, fromJsonT);
}

///
@JsonSerializable(genericArgumentFactories: true, createToJson: false)
class Web3MQListResponse<T> {
  /// The web3mq status code
  final int code;

  /// The message associated to the code
  @JsonKey(name: "msg")
  final String? message;

  ///
  late Page<T> data;

  ///
  Web3MQListResponse(this.code, this.message, this.data);

  factory Web3MQListResponse.fromJson(
          Map<String, dynamic> json, T Function(dynamic json) fromJsonT) =>
      _$Web3MQListResponseFromJson<T>(json, fromJsonT);
}

///
@JsonSerializable(createToJson: false)
class CommonResponse extends Web3MQResponse {
  @override
  get data => null;

  CommonResponse(super.code, super.message, super.data);

  static CommonResponse fromJson(Map<String, dynamic> json) =>
      _$CommonResponseFromJson(json);

  @override
  String toString() => 'CommonResponse(code: $code, '
      'message: $message, ';
}

/// Model response for [Web3MQNetworkError] data
@JsonSerializable()
class ErrorResponse extends Web3MQResponse {
  ErrorResponse(super.code, super.message, super.data);

  /// Create a new instance from a json
  static ErrorResponse fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$ErrorResponseToJson(this);

  @override
  String toString() => 'ErrorResponse(code: $code, '
      'message: $message, ';
}

@JsonSerializable(createToJson: false)
class MySubscribeTopicsResponse {
  final int code;

  /// The message associated to the code
  @JsonKey(name: "msg")
  final String? message;

  final List<Topic> data;

  MySubscribeTopicsResponse(this.code, this.message, this.data);

  /// Create a new instance from a json
  static MySubscribeTopicsResponse fromJson(Map<String, dynamic> json) =>
      _$MySubscribeTopicsResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class NotificationPayload {
  ///
  String title;

  ///
  String content;

  ///
  String type;

  ///
  int version;

  ///
  @JsonKey(fromJson: _dateTimeFromJson)
  DateTime timestamp;

  NotificationPayload(
      this.title, this.content, this.type, this.version, this.timestamp);

  /// Create a new instance from a json
  static NotificationPayload fromJson(Map<String, dynamic> json) =>
      _$NotificationPayloadFromJson(json);
}

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class NotificationQueryResponse {
  String cipherSuite;

  String from;

  String fromSign;

  @JsonKey(name: "messageid")
  String messageId;

  NotificationPayload payload;

  String payloadType;

  String status;

  String topic;

  /// Create a new instance from a json
  static NotificationQueryResponse fromJson(Map<String, dynamic> json) =>
      _$NotificationQueryResponseFromJson(json);

  NotificationQueryResponse(this.cipherSuite, this.from, this.fromSign,
      this.messageId, this.payload, this.payloadType, this.status, this.topic);

  factory NotificationQueryResponse.fromNotificationMessage(Notification item) {
    final string = utf8.decode(item.payload);
    final Map<String, dynamic> map = jsonDecode(string);
    final payload = NotificationPayload.fromJson(map);
    return NotificationQueryResponse(
        item.cipherSuite,
        item.userId,
        item.signature,
        item.id,
        payload,
        item.payloadType,
        (item.read ?? false) ? "read" : "received",
        item.topicId);
  }
}

///
@JsonSerializable()
class Topic {
  @JsonKey(name: "topicid")
  final String topicId;

  @JsonKey(name: "topic_name")
  final String name;

  @JsonKey(name: "create_at")
  final int? creationTime;

  /// To json
  Map<String, dynamic> toJson() => _$TopicToJson(this);

  /// Create a new instance from a json
  static Topic fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);

  Topic(this.topicId, this.name, this.creationTime);
}

@JsonSerializable(createToJson: false)
class UserInfo {
  @JsonKey(name: "did_type")
  final String didType;

  @JsonKey(name: "did_value")
  final String didValue;

  @JsonKey(name: "userid")
  final String userId;

  @JsonKey(name: "main_pubkey")
  final String? mainKey;

  @JsonKey(name: "pubkey")
  final String? pubKey;

  @JsonKey(name: "pubkey_type")
  final String? pubKeyType;

  @JsonKey(name: "wallet_address")
  final String? walletAddress;

  @JsonKey(name: "wallet_type")
  final String? walletType;

  @JsonKey(name: "signature_content")
  final String? signatureContent;

  @JsonKey(name: "did_signature")
  final String? didSignature;

  final int? timestamp;

  /// Create a new instance from a json
  static UserInfo fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);

  UserInfo(
      this.didType,
      this.didValue,
      this.userId,
      this.mainKey,
      this.pubKey,
      this.pubKeyType,
      this.walletAddress,
      this.walletType,
      this.signatureContent,
      this.didSignature,
      this.timestamp);
}

@JsonSerializable(createToJson: false)
class UserRegisterResponse {
  @JsonKey(name: "userid")
  String userId;

  @JsonKey(name: "did_value")
  String didValue;

  @JsonKey(name: "did_type")
  String didType;

  /// Create a new instance from a json
  static UserRegisterResponse fromJson(Map<String, dynamic> json) =>
      _$UserRegisterResponseFromJson(json);

  UserRegisterResponse(this.userId, this.didValue, this.didType);
}

@JsonSerializable(createToJson: false)
class UserLoginResponse {
  @JsonKey(name: "userid")
  String userId;

  @JsonKey(name: "did_value")
  String didValue;

  @JsonKey(name: "did_type")
  String didType;

  /// Create a new instance from a json
  static UserLoginResponse fromJson(Map<String, dynamic> json) =>
      _$UserLoginResponseFromJson(json);

  UserLoginResponse(this.userId, this.didValue, this.didType);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ChannelModel {
  ///
  /// The topic of this channel
  final String topic;

  /// The topic type of this channel
  final String topicType;

  /// The chat id of this channel
  @JsonKey(name: 'chatid')
  final String channelId;

  /// The chat type of this channel
  /// eg. user, group, topic
  @JsonKey(name: 'chat_type')
  final String channelType;

  /// The name of this channel
  @JsonKey(name: 'chat_name')
  final String name;

  /// The avatar url of this channel
  final String? avatarUrl;

  /// Constructor used for json serialization
  ChannelModel(
    this.topic,
    this.topicType,
    this.channelId,
    this.channelType,
    this.name,
    this.avatarUrl,
    this.lastMessageAt,
    this.deletedAt, {
    int? unreadMessageCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : unreadMessageCount = unreadMessageCount ?? 0,
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Create a new instance from a json
  factory ChannelModel.fromJson(Map<String, dynamic> json) =>
      _$ChannelModelFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$ChannelModelToJson(this);

  /// The date of the last message
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  DateTime? lastMessageAt;

  /// The date of channel deletion
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final DateTime? deletedAt;

  /// The date of channel creation
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final DateTime createdAt;

  /// The date of the last channel update
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final DateTime updatedAt;

  /// The unread message count
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  int unreadMessageCount;

  /// Creates a copy of [ChannelModel] with specified attributes overridden.
  ChannelModel copyWith(
          {String? topic,
          String? topicType,
          String? channelId,
          String? channelType,
          String? name,
          String? avatarUrl,
          DateTime? lastMessageAt,
          DateTime? createdAt,
          DateTime? updatedAt,
          DateTime? deletedAt,
          int? unreadMessageCount}) =>
      ChannelModel(
          topic ?? this.topic,
          topicType ?? this.topicType,
          channelId ?? this.channelId,
          channelType ?? this.channelType,
          name ?? this.name,
          avatarUrl ?? this.avatarUrl,
          lastMessageAt ?? this.lastMessageAt,
          deletedAt ?? this.deletedAt);
}

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class UserModel {
  /// The user if of this user
  @JsonKey(name: 'userid')
  final String userId;

  /// The nickname of this user
  final String? nickname;

  /// The avatar url of this user
  final String? avatarUrl;

  @JsonKey(includeToJson: false, includeFromJson: false)
  String get name {
    if (null != nickname && nickname!.isNotEmpty) {
      return nickname!;
    } else {
      return userId;
    }
  }

  /// Date of user creation.
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final DateTime createdAt;

  /// Date of last user update.
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final DateTime updatedAt;

  /// Creates a copy of [UserModel] with specified attributes overridden.
  UserModel(
      {required this.userId,
      this.nickname,
      this.avatarUrl,
      DateTime? createdAt,
      DateTime? updatedAt})
      : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Create a new instance from a json
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

@JsonSerializable()
class Member extends Equatable {
  /// The user id of this member
  @JsonKey(name: 'userid')
  final String userId;

  /// The nickname of this member
  @JsonKey(name: 'nickname')
  final String? nickName;

  /// The avatar url of this member
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;

  final DateTime? _createdAt;

  /// Reserved field indicating when the message was created.
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  DateTime get createdAt => _createdAt ?? DateTime.now();

  final DateTime? _updatedAt;

  /// Reserved field indicating when the messaÏge was updated last time.
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  DateTime get updatedAt => _updatedAt ?? DateTime.now();

  ///
  Member(this.userId, this.nickName, this.avatarUrl,
      {DateTime? createdAt, DateTime? updatedAt})
      : _createdAt = createdAt,
        _updatedAt = updatedAt;

  @override
  List<Object?> get props => [userId, nickName, avatarUrl];

  /// To json
  Map<String, dynamic> toJson() => _$MemberToJson(this);

  /// Create a new instance from a json
  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
}

@JsonSerializable()
class Notification {
  @JsonKey(name: "messageId")
  final String id;

  ///
  final List<int> payload;

  /// The type of [payload].
  ///
  /// When payload is encode from json object, it should be [WSPayloadType.json],
  /// as payload is encode from text, it should be [WSPayloadType.plainText].
  final String payloadType;

  /// User id who send this message.
  @JsonKey(name: "comeFrom")
  final String userId;

  ///
  @JsonKey(name: "fromSign")
  final String signature;

  @JsonKey(name: "contentTopic")
  final String topicId;

  ///
  final String cipherSuite;

  ///
  final int timestamp;

  ///
  final bool? read;

  ///
  final int? readTimestamp;

  Notification(
      this.id,
      this.payload,
      this.payloadType,
      this.userId,
      this.signature,
      this.cipherSuite,
      this.timestamp,
      this.read,
      this.readTimestamp,
      this.topicId);

  /// Create a new instance from a json
  static Notification fromJson(Map<String, dynamic> json) =>
      _$NotificationFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$NotificationToJson(this);
}

///
@JsonSerializable()
class MessageStatus {
  ///
  final String? status;

  ///
  final int? timestamp;

  ///
  MessageStatus(this.status, this.timestamp);

  /// To json
  Map<String, dynamic> toJson() => _$MessageStatusToJson(this);

  /// Create a new instance from a json
  factory MessageStatus.fromJson(Map<String, dynamic> json) =>
      _$MessageStatusFromJson(json);
}

///
@JsonSerializable(fieldRename: FieldRename.snake)
class Message {
  ///
  final String topic;

  ///
  final String from;

  ///
  final String cipherSuite;

  ///
  @JsonKey(name: 'messageid')
  final String messageId;

  /// The message type [MessageType]
  final String? messageType;

  ///
  final int timestamp;

  /// The base64 encoded string
  @JsonKey(name: 'payload')
  final String? payload;

  @JsonKey(name: "threadid")
  final String? threadId;

  /// The extra data.
  final Map<String, String>? extraData;

  /// The status of this message
  final MessageStatus? messageStatus;

  @JsonKey(defaultValue: MessageSendingStatus.sent)
  final MessageSendingStatus? _sendingStatus;

  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  MessageSendingStatus get sendingStatus =>
      _sendingStatus ??
      ((messageStatus?.status == 'received' || messageStatus?.status == 'read')
          ? MessageSendingStatus.sent
          : MessageSendingStatus.failed);

  /// User who sent the message.
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final UserModel? user;

  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final String? text;

  final DateTime? _createdAt;

  /// Reserved field indicating when the message was created.
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  DateTime get createdAt => _createdAt ?? DateTime.now();

  final DateTime? _updatedAt;

  /// Reserved field indicating when the messaÏge was updated last time.
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  DateTime get updatedAt => _updatedAt ?? DateTime.now();

  ///
  Message(
      this.topic,
      this.from,
      this.cipherSuite,
      this.messageId,
      this.timestamp,
      this.messageStatus,
      this.user,
      this.text,
      this.threadId,
      this.messageType,
      this.extraData,
      {DateTime? createdAt,
      DateTime? updatedAt,
      MessageSendingStatus? sendingStatus,
      this.payload})
      : _createdAt = createdAt,
        _updatedAt = createdAt,
        _sendingStatus = sendingStatus;

  /// Create a new instance from a json
  Map<String, dynamic> toJson() => _$MessageToJson(this);

  /// Creates a new instance from a json
  factory Message.fromJson(Map<String, dynamic> json) {
    final message = _$MessageFromJson(json)
        .copyWith(sendingStatus: MessageSendingStatus.sent);
    final text = _decodeTextFromPayload(message.payload);
    return message.copyWith(text: text);
  }

  Message copyWith({
    String? topic,
    String? from,
    String? cipherSuite,
    String? messageId,
    int? timestamp,
    MessageStatus? messageStatus,
    UserModel? user,
    String? text,
    String? threadId,
    String? messageType,
    Map<String, String>? extraData,
    DateTime? createdAt,
    DateTime? updatedAt,
    MessageSendingStatus? sendingStatus,
    String? payload,
  }) {
    return Message(
      topic ?? this.topic,
      from ?? this.from,
      cipherSuite ?? this.cipherSuite,
      messageId ?? this.messageId,
      timestamp ?? this.timestamp,
      messageStatus ?? this.messageStatus,
      user ?? this.user,
      text ?? this.text,
      threadId ?? this.threadId,
      messageType ?? this.messageType,
      extraData ?? this.extraData,
      createdAt: createdAt ?? _createdAt,
      updatedAt: updatedAt ?? _updatedAt,
      sendingStatus: sendingStatus ?? _sendingStatus,
      payload: payload ?? this.payload,
    );
  }

  static String? _decodeTextFromPayload(String? payload) {
    if (null == payload) return null;
    final bytes = base64Decode(payload);
    return utf8.decode(bytes);
  }
}

@JsonSerializable(createToJson: false)
class SyncResponse {
  final int code;

  @JsonKey(name: 'msg')
  final String? message;

  final Map<String, Map<String, String>> data;

  SyncResponse(this.code, this.message, this.data);

  /// Creates a new instance from a json
  factory SyncResponse.fromJson(Map<String, dynamic> json) =>
      _$SyncResponseFromJson(json);
}

class FollowStatus {
  static final String following = 'following';
  static final String followEach = 'followEach';
  static final String follower = 'follower';
  static final String empty = '';
}

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class FollowUser {
  @JsonKey(name: 'userid')
  final String userId;

  final String followStatus;

  final String? walletAddress;

  final String? walletType;

  final String? avatarUrl;

  final String? nickname;

  FollowUser(this.userId, this.followStatus, this.walletAddress,
      this.walletType, this.avatarUrl, this.nickname);

  /// Creates a new instance from a json
  factory FollowUser.fromJson(Map<String, dynamic> json) =>
      _$FollowUserFromJson(json);
}

/// The thread model
@JsonSerializable()
class Thread {
  /// The id of the thread
  @JsonKey(name: 'threadid')
  final String threadId;

  /// The id of the topic
  @JsonKey(name: 'topicid')
  final String topicId;

  /// The id of the user
  @JsonKey(name: 'userid')
  final String userId;

  /// The name of the thread
  @JsonKey(name: 'thread_name')
  final String? threadName;

  /// The timestamp of the thread
  @JsonKey(name: 'timestamp')
  final int timestamp;

  /// Creates a new instance
  Thread(this.threadId, this.topicId, this.userId, this.threadName,
      this.timestamp);

  /// To json
  Map<String, dynamic> toJson() => _$ThreadToJson(this);

  /// Creates a new instance from a json
  factory Thread.fromJson(Map<String, dynamic> json) => _$ThreadFromJson(json);
}

@JsonSerializable()
class ThreadListResponse {
  ///
  @JsonKey(name: 'thread_list')
  final List<Thread> threadList;

  /// The count of [threadList]
  @JsonKey(name: 'total_count')
  final int count;

  ///
  ThreadListResponse(this.threadList, this.count);

  /// Creates a new instance from a json
  factory ThreadListResponse.fromJson(Map<String, dynamic> json) =>
      _$ThreadListResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class ThreadMessageListResponse {
  ///
  final int total;

  ///
  final List<Message> result;

  ///
  ThreadMessageListResponse(this.total, this.result);

  /// Creates a new instance from a json
  factory ThreadMessageListResponse.fromJson(Map<String, dynamic> json) =>
      _$ThreadMessageListResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class Group {
  @JsonKey(name: 'groupid')
  final String groupId;

  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;

  @JsonKey(name: 'group_name')
  final String? groupName;

  /// Creates a new instance
  Group(this.groupId, this.avatarUrl, this.groupName);

  /// Creates a new instance from a json
  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
}
