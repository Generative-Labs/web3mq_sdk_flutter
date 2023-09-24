import 'package:flutter/foundation.dart';
import 'package:mutex/mutex.dart';

import '../../web3mq.dart';
import '../client/persistence_client.dart';
import 'db/drift_chat_database.dart';
import 'db/shared/native_db.dart';

/// Various connection modes on which [Web3MQClientPersistenceClient] can work
enum ConnectionMode {
  /// Connects the [PersistenceClient] on a regular/default isolate
  regular,

  /// Connects the [PersistenceClient] on a background isolate
  background,
}

/// Signature for a function which provides instance of [DriftChatDatabase]
typedef DatabaseProvider = DriftChatDatabase Function(String, ConnectionMode);

/// A [DriftChatDatabase] based implementation of the [PersistenceClient]
class Web3MQPersistenceClient extends PersistenceClient {
  /// Creates a new instance of the persistence client
  Web3MQPersistenceClient({
    /// Connection mode on which the client will work
    ConnectionMode connectionMode = ConnectionMode.regular,
    Level logLevel = Level.WARNING,

    /// Whether to use an experimental storage implementation on the web
    /// that uses IndexedDB if the current browser supports it.
    /// Otherwise, falls back to the local storage based implementation.
    bool webUseExperimentalIndexedDb = false,
    LogHandlerFunction? logHandlerFunction,
  })  : _connectionMode = connectionMode,
        _webUseIndexedDbIfSupported = webUseExperimentalIndexedDb,
        _logger = Logger.detached('💽')..level = logLevel {
    _logger.onRecord
        .listen(logHandlerFunction ?? Web3MQLogger.defaultLogHandler);
  }

  /// [DriftChatDatabase] instance used by this client.
  @visibleForTesting
  DriftChatDatabase? db;

  final Logger _logger;
  final ConnectionMode _connectionMode;
  final bool _webUseIndexedDbIfSupported;
  final _mutex = ReadWriteMutex();

  Future<T> _readProtected<T>(AsyncValueGetter<T> func) =>
      _mutex.protectRead(func);

  bool get _debugIsConnected {
    assert(() {
      if (db == null) {
        throw StateError('''
        $runtimeType hasn't been connected yet or used after `disconnect` 
        was called. Consider calling `connect` to create a connection. 
          ''');
      }
      return true;
    }(), '');
    return true;
  }

  Future<DriftChatDatabase> _defaultDatabaseProvider(
    String userId,
    ConnectionMode mode,
  ) =>
      SharedDB.constructDatabase(
        userId,
        connectionMode: mode,
        webUseIndexedDbIfSupported: _webUseIndexedDbIfSupported,
      );

  @override
  Future<void> connect(
    String userId, {
    DatabaseProvider? databaseProvider, // Used only for testing
  }) async {
    if (db != null) {
      throw Exception(
        'An instance of Web3MQDatabase is already connected.\n'
        'disconnect the previous instance before connecting again.',
      );
    }
    db = databaseProvider?.call(userId, _connectionMode) ??
        await _defaultDatabaseProvider(userId, _connectionMode);
  }

  @override
  Future<Event?> getConnectionInfo() {
    assert(_debugIsConnected, '');
    _logger.info('getConnectionInfo');
    return _readProtected(() => db!.connectionEventDao.connectionEvent);
  }

  @override
  Future<void> updateConnectionInfo(Event event) {
    assert(_debugIsConnected, '');
    _logger.info('updateConnectionInfo');
    return _readProtected(
      () => db!.connectionEventDao.updateConnectionEvent(event),
    );
  }

  @override
  Future<void> updateLastSyncAt(DateTime lastSyncAt) {
    assert(_debugIsConnected, '');
    _logger.info('updateLastSyncAt');
    return _readProtected(
      () => db!.connectionEventDao.updateLastSyncAt(lastSyncAt),
    );
  }

  @override
  Future<DateTime?> getLastSyncAt() {
    assert(_debugIsConnected, '');
    _logger.info('getLastSyncAt');
    return _readProtected(() => db!.connectionEventDao.lastSyncAt);
  }

  @override
  Future<void> deleteChannels(List<String> topics) {
    assert(_debugIsConnected, '');
    _logger.info('deleteChannels');
    return _readProtected(() => db!.channelDao.deleteChannelByTopics(topics));
  }

  @override
  Future<List<String>> getChannelTopics() {
    assert(_debugIsConnected, '');
    _logger.info('getChannelTopics');
    return _readProtected(() => db!.channelDao.topics);
  }

  @override
  Future<void> markAllToReadByTopic(String topic) {
    assert(_debugIsConnected, '');
    _logger.info('markAllToReadByTopic');
    return _readProtected(() async {
      // mark channel.unreadCount to zero.
      final channel = await db!.channelDao.getChannelByTopic(topic);
      if (null != channel) {
        final finalChannel = channel.copyWith(unreadMessageCount: 0);
        db!.channelDao.updateChannels([finalChannel]);
      }
      return db!.messageDao.updateAllToReadByTopic(topic);
    });
  }

  @override
  Future<Message?> getMessageById(String messageId) {
    assert(_debugIsConnected, '');
    _logger.info('getMessageById');
    return _readProtected(() => db!.messageDao.getMessageById(messageId));
  }

  @override
  Future<void> deleteMessageByIds(List<String> messageIds) {
    assert(_debugIsConnected, '');
    _logger.info('deleteMessageByIds');
    return _readProtected(() => db!.messageDao.deleteMessageByIds(messageIds));
  }

  @override
  Future<void> deleteMessageByTopics(List<String> topics) {
    assert(_debugIsConnected, '');
    _logger.info('deleteMessageByTopics');
    return _readProtected(() => db!.messageDao.deleteMessageByTopics(topics));
  }

  @override
  Future<List<Member>> getMembersByTopic(String topic) {
    assert(_debugIsConnected, '');
    _logger.info('getMembersByTopic');
    return _readProtected(() => db!.memberDao.getMembersByTopic(topic));
  }

  @override
  Future<ChannelModel?> getChannelByTopic(String topic) {
    assert(_debugIsConnected, '');
    _logger.info('getChannelByTopic');
    return _readProtected(() => db!.channelDao.getChannelByTopic(topic));
  }

  @override
  Future<List<Message>> getMessagesByTopic(
    String topic, {
    Pagination? messagePagination,
  }) {
    assert(_debugIsConnected, '');
    _logger.info('getMessagesByTopic');
    return _readProtected(
      () => db!.messageDao.getMessagesByTopic(
        topic,
        messagePagination: messagePagination,
      ),
    );
  }

  @override
  Future<Map<String, List<Message>>> getChannelThreads(String topic) {
    assert(_debugIsConnected, '');
    _logger.info('getChannelThreads');
    return _readProtected(() async {
      final messages = await db!.messageDao.getThreadMessages(topic);
      final messageByParentIdDictionary = <String, List<Message>>{};
      for (final message in messages) {
        final parentId = message.threadId!;
        messageByParentIdDictionary[parentId] = [
          ...messageByParentIdDictionary[parentId] ?? [],
          message,
        ];
      }
      return messageByParentIdDictionary;
    });
  }

  @override
  Future<List<ChannelState>> getChannelStates({
    Pagination? paginationParams,
  }) {
    assert(_debugIsConnected, '');
    _logger.info('getChannelStates');
    return _readProtected(
      () async {
        final channels = await db!.channelQueryDao.getChannels();

        List<ChannelState> channelStates = (await Future.wait(
          channels.map((e) => getChannelStateByChannelId(e.channelId)),
        ))
            .where((state) => state != null)
            .map((state) => state!)
            .toList();

        chainedComparator(ChannelState a, ChannelState b) {
          final dateA = a.channel.lastMessageAt ?? a.channel.createdAt;
          final dateB = b.channel.lastMessageAt ?? b.channel.createdAt;
          return dateB.compareTo(dateA);
        }

        channelStates.sort(chainedComparator);
        if (paginationParams != null) {
          int startIndex =
              ((paginationParams.page ?? 1) - 1) * paginationParams.size;
          return channelStates
              .skip(startIndex)
              .take(paginationParams.size)
              .toList();
        }

        return channelStates;
      },
    );
  }

  @override
  Future<void> updateChannelQueries(
    List<String> topics, {
    bool clearQueryCache = false,
  }) {
    assert(_debugIsConnected, '');
    _logger.info('updateChannelQueries');
    return _readProtected(
      () => db!.channelQueryDao.updateChannelQueries(
        topics,
        clearQueryCache: clearQueryCache,
      ),
    );
  }

  @override
  Future<void> updateChannels(List<ChannelModel> channels) {
    assert(_debugIsConnected, '');
    _logger.info('updateChannels');
    return _readProtected(() => db!.channelDao.updateChannels(channels));
  }

  @override
  Future<void> bulkUpdateMembers(Map<String, List<Member>?> members) {
    assert(_debugIsConnected, '');
    _logger.info('bulkUpdateMembers');
    return _readProtected(() => db!.memberDao.bulkUpdateMembers(members));
  }

  @override
  Future<void> bulkUpdateMessages(Map<String, List<Message>?> messages) {
    assert(_debugIsConnected, '');
    _logger.info('bulkUpdateMessages');
    return _readProtected(() => db!.messageDao.bulkUpdateMessages(messages));
  }

  @override
  Future<void> updateUsers(List<UserModel> users) {
    assert(_debugIsConnected, '');
    _logger.info('updateUsers');
    return _readProtected(() => db!.userDao.updateUsers(users));
  }

  @override
  Future<void> deleteMembersByTopics(List<String> topics) {
    assert(_debugIsConnected, '');
    _logger.info('deleteMembersByTopics');
    return _readProtected(() => db!.memberDao.deleteMemberByTopics(topics));
  }

  @override
  Future<void> updateChannelStates(List<ChannelState> channelStates) {
    assert(_debugIsConnected, '');
    _logger.info('updateChannelStates');
    return _readProtected(
      () async => db!.transaction(
        () async {
          await super.updateChannelStates(channelStates);
        },
      ),
    );
  }

  @override
  Future<void> disconnect({bool flush = false}) async =>
      _mutex.protectWrite(() async {
        _logger.info('disconnect');
        if (db != null) {
          _logger.info('Disconnecting');
          if (flush) {
            _logger.info('Flushing');
            await db!.flush();
          }
          await db!.disconnect();
          db = null;
        }
      });
}
