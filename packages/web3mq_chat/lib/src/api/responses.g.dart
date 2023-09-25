// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Web3MQResponse<T> _$Web3MQResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    Web3MQResponse<T>(
      json['code'] as int,
      json['msg'] as String?,
      _$nullableGenericFromJson(json['data'], fromJsonT),
    );

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) =>
    input == null ? null : fromJson(input);

Page<T> _$PageFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    Page<T>(
      json['total_count'] as int? ?? 0,
      (json['data_list'] as List<dynamic>?)?.map(fromJsonT).toList() ?? [],
    );

Web3MQListResponse<T> _$Web3MQListResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    Web3MQListResponse<T>(
      json['code'] as int,
      json['msg'] as String?,
      Page<T>.fromJson(
          json['data'] as Map<String, dynamic>, (value) => fromJsonT(value)),
    );

CommonResponse _$CommonResponseFromJson(Map<String, dynamic> json) =>
    CommonResponse(
      json['code'] as int,
      json['msg'] as String?,
      json['data'],
    );

ErrorResponse _$ErrorResponseFromJson(Map<String, dynamic> json) =>
    ErrorResponse(
      json['code'] as int,
      json['msg'] as String?,
      json['data'],
    );

Map<String, dynamic> _$ErrorResponseToJson(ErrorResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.message,
      'data': instance.data,
    };

MySubscribeTopicsResponse _$MySubscribeTopicsResponseFromJson(
        Map<String, dynamic> json) =>
    MySubscribeTopicsResponse(
      json['code'] as int,
      json['msg'] as String?,
      (json['data'] as List<dynamic>)
          .map((e) => Topic.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

NotificationPayload _$NotificationPayloadFromJson(Map<String, dynamic> json) =>
    NotificationPayload(
      json['title'] as String,
      json['content'] as String,
      json['type'] as String,
      json['version'] as int,
      _dateTimeFromJson(json['timestamp'] as int),
    );

NotificationQueryResponse _$NotificationQueryResponseFromJson(
        Map<String, dynamic> json) =>
    NotificationQueryResponse(
      json['cipher_suite'] as String,
      json['from'] as String,
      json['from_sign'] as String,
      json['messageid'] as String,
      NotificationPayload.fromJson(json['payload'] as Map<String, dynamic>),
      json['payload_type'] as String,
      json['status'] as String,
      json['topic'] as String,
    );

Topic _$TopicFromJson(Map<String, dynamic> json) => Topic(
      json['topicid'] as String,
      json['topic_name'] as String,
      json['create_at'] as int?,
    );

Map<String, dynamic> _$TopicToJson(Topic instance) => <String, dynamic>{
      'topicid': instance.topicId,
      'topic_name': instance.name,
      'create_at': instance.creationTime,
    };

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) => UserInfo(
      json['did_type'] as String,
      json['did_value'] as String,
      json['userid'] as String,
      json['main_pubkey'] as String?,
      json['pubkey'] as String?,
      json['pubkey_type'] as String?,
      json['wallet_address'] as String?,
      json['wallet_type'] as String?,
      json['signature_content'] as String?,
      json['did_signature'] as String?,
      json['timestamp'] as int?,
    )..cyberProfile = json['cyberProfile'] == null
        ? null
        : CyberProfile.fromJson(json['cyberProfile'] as Map<String, dynamic>);

UserRegisterResponse _$UserRegisterResponseFromJson(
        Map<String, dynamic> json) =>
    UserRegisterResponse(
      json['userid'] as String,
      json['did_value'] as String,
      json['did_type'] as String,
    );

UserLoginResponse _$UserLoginResponseFromJson(Map<String, dynamic> json) =>
    UserLoginResponse(
      json['userid'] as String,
      json['did_value'] as String,
      json['did_type'] as String,
    );

ChannelModel _$ChannelModelFromJson(Map<String, dynamic> json) => ChannelModel(
      json['topic'] as String,
      json['topic_type'] as String,
      json['chatid'] as String,
      json['chat_type'] as String,
      json['chat_name'] as String,
      json['avatar_url'] as String?,
      json['last_message_at'] == null
          ? null
          : DateTime.parse(json['last_message_at'] as String),
      json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      unreadMessageCount: json['unread_message_count'] as int?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ChannelModelToJson(ChannelModel instance) =>
    <String, dynamic>{
      'topic': instance.topic,
      'topic_type': instance.topicType,
      'chatid': instance.channelId,
      'chat_type': instance.channelType,
      'chat_name': instance.name,
      'avatar_url': instance.avatarUrl,
      'last_message_at': readonly(instance.lastMessageAt),
      'deleted_at': readonly(instance.deletedAt),
      'created_at': readonly(instance.createdAt),
      'updated_at': readonly(instance.updatedAt),
      'unread_message_count': readonly(instance.unreadMessageCount),
    };

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      userId: json['userid'] as String,
      nickname: json['nickname'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Member _$MemberFromJson(Map<String, dynamic> json) => Member(
      json['userid'] as String,
      json['nickname'] as String?,
      json['avatar_url'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$MemberToJson(Member instance) => <String, dynamic>{
      'userid': instance.userId,
      'nickname': instance.nickName,
      'avatar_url': instance.avatarUrl,
      'createdAt': readonly(instance.createdAt),
      'updatedAt': readonly(instance.updatedAt),
    };

MessageStatus _$MessageStatusFromJson(Map<String, dynamic> json) =>
    MessageStatus(
      json['status'] as String?,
      json['timestamp'] as int?,
    );

Map<String, dynamic> _$MessageStatusToJson(MessageStatus instance) =>
    <String, dynamic>{
      'status': instance.status,
      'timestamp': instance.timestamp,
    };

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      json['topic'] as String,
      json['from'] as String,
      json['cipher_suite'] as String,
      json['messageid'] as String,
      json['timestamp'] as int,
      json['message_status'] == null
          ? null
          : MessageStatus.fromJson(
              json['message_status'] as Map<String, dynamic>),
      json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      json['text'] as String?,
      json['threadid'] as String?,
      json['message_type'] as String?,
      (json['extra_data'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      sendingStatus: $enumDecodeNullable(
          _$MessageSendingStatusEnumMap, json['sending_status']),
      payload: json['payload'] as String?,
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'topic': instance.topic,
      'from': instance.from,
      'cipher_suite': instance.cipherSuite,
      'messageid': instance.messageId,
      'message_type': instance.messageType,
      'timestamp': instance.timestamp,
      'payload': instance.payload,
      'threadid': instance.threadId,
      'extra_data': instance.extraData,
      'message_status': instance.messageStatus,
      'sending_status': readonly(instance.sendingStatus),
      'user': readonly(instance.user),
      'text': readonly(instance.text),
      'created_at': readonly(instance.createdAt),
      'updated_at': readonly(instance.updatedAt),
    };

const _$MessageSendingStatusEnumMap = {
  MessageSendingStatus.sending: 'sending',
  MessageSendingStatus.failed: 'failed',
  MessageSendingStatus.sent: 'sent',
};

SyncResponse _$SyncResponseFromJson(Map<String, dynamic> json) => SyncResponse(
      json['code'] as int,
      json['msg'] as String?,
      (json['data'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, Map<String, String>.from(e as Map)),
      ),
    );

FollowUser _$FollowUserFromJson(Map<String, dynamic> json) => FollowUser(
      json['userid'] as String,
      json['follow_status'] as String,
      json['wallet_address'] as String?,
      json['wallet_type'] as String?,
      json['avatar_url'] as String?,
      json['nickname'] as String?,
    )..cyberStatus = json['cyber_status'] == null
        ? null
        : CyberFollowStatus.fromJson(
            json['cyber_status'] as Map<String, dynamic>);

Thread _$ThreadFromJson(Map<String, dynamic> json) => Thread(
      json['threadid'] as String,
      json['topicid'] as String,
      json['userid'] as String,
      json['thread_name'] as String?,
      json['timestamp'] as int,
    );

Map<String, dynamic> _$ThreadToJson(Thread instance) => <String, dynamic>{
      'threadid': instance.threadId,
      'topicid': instance.topicId,
      'userid': instance.userId,
      'thread_name': instance.threadName,
      'timestamp': instance.timestamp,
    };

ThreadListResponse _$ThreadListResponseFromJson(Map<String, dynamic> json) =>
    ThreadListResponse(
      (json['thread_list'] as List<dynamic>)
          .map((e) => Thread.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['total_count'] as int,
    );

Map<String, dynamic> _$ThreadListResponseToJson(ThreadListResponse instance) =>
    <String, dynamic>{
      'thread_list': instance.threadList,
      'total_count': instance.count,
    };

ThreadMessageListResponse _$ThreadMessageListResponseFromJson(
        Map<String, dynamic> json) =>
    ThreadMessageListResponse(
      json['total'] as int,
      (json['result'] as List<dynamic>)
          .map((e) => Message.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Group _$GroupFromJson(Map<String, dynamic> json) => Group(
      json['groupid'] as String,
      json['avatar_url'] as String?,
      json['group_name'] as String?,
    );
