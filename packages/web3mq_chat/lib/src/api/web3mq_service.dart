import 'package:logging/logging.dart';
import 'package:web3mq/src/api/chat_api.dart';
import 'package:web3mq/src/api/contacts.api.dart';
import 'package:web3mq/src/api/group_api.dart';
import 'package:web3mq/src/api/utils_api.dart';

import '../http/http_client.dart';
import '../utils/signer.dart';
import 'notification_api.dart';
import 'topic_api.dart';
import 'user_api.dart';

class Web3MQService {
  /// Initialize a new web3mq service
  Web3MQService(String apiKey,
      {Web3MQHttpClient? client,
      Signer? signer,
      Web3MQHttpClientOptions? options,
      Logger? logger})
      : _client = client ??
            Web3MQHttpClient(apiKey, options: options, logger: logger),
        _signer = signer ?? Signer.instance;

  final Web3MQHttpClient _client;

  final Signer _signer;

  NotificationApi? _notification;
  UserApi? _user;
  TopicApi? _topic;
  ChatApi? _chat;
  ContactsApi? _contacts;
  GroupApi? _group;
  UtilsApi? _utils;

  void switchUrl(String url) {
    _client.switchUrl(url);
  }

  /// Api dedicated to users operations
  NotificationApi get notification =>
      _notification ??= NotificationApi(_client, _signer);

  /// Api for user register or getting user info.
  UserApi get user => _user ??= UserApi(_client, _signer);

  /// Api for creating and subscribing topic.
  TopicApi get topic => _topic ??= TopicApi(_client, _signer);

  /// Api for chat.
  ChatApi get chat => _chat ??= ChatApi(_client, _signer);

  /// Api for contacts.
  ContactsApi get contacts => _contacts ??= ContactsApi(_client, _signer);

  /// Api for group.
  GroupApi get group => _group ??= GroupApi(_client, _signer);

  /// Api for utils.
  UtilsApi get uitls => _utils ??= UtilsApi();
}
