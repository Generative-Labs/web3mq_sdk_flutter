import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/export.dart';
import '../utils/keypair.dart';
import 'record.dart';

/// Session proposal storage.
abstract class Storage {
  /// Set session proposal.
  Future<void> setSessionProposal(SessionProposal sessionProposal);

  /// Get session proposal.
  Future<SessionProposal?> getSessionProposal(String proposalId);

  /// Remove session proposal.
  Future<void> removeSessionProposal(String proposalId);

  /// Get session.
  Future<Session?> getSession(String topic);

  Future<List<Session>> getAllSessions();

  /// Set session.
  Future<void> setSession(Session session);

  /// Remove session.
  Future<void> removeSession(String topic);

  /// Get record.
  Future<Record?> getRecord(String topic);

  /// Set record.
  Future<void> setRecord(Record record);

  /// Remove record.
  Future<void> removeRecord(String topic);

  /// Clear all session proposals.
  Future<void> clear();
}

///
class Web3MQStorage extends Storage {
  @override
  Future<SessionProposal?> getSessionProposal(String proposalId) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString =
        prefs.getString(_getCacheKey(_sessionProposalCachePrefix, proposalId));
    if (jsonString == null) {
      return null;
    }
    final json = jsonDecode(jsonString);
    return SessionProposal.fromJson(json);
  }

  @override
  Future<void> removeSessionProposal(String proposalId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_getCacheKey(_sessionProposalCachePrefix, proposalId));
  }

  @override
  Future<void> setSessionProposal(SessionProposal sessionProposal) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
        _getCacheKey(_sessionProposalCachePrefix, sessionProposal.id),
        jsonEncode(sessionProposal));
  }

  @override
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.getKeys().forEach((key) {
      if (key.startsWith(_sessionProposalCachePrefix)) {
        prefs.remove(key);
      }
    });
  }

  final _sessionProposalCachePrefix = 'com.web3mq.dappmq.session_proposal_';
  final _sessionCachePrefix = 'com.web3mq.dappmq.session_';
  final _recordPrefix = 'com.web3mq.dappmq.record_';

  ///
  String _getCacheKey(String prefix, String proposalId) => "$prefix$proposalId";

  @override
  Future<Session?> getSession(String topic) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString =
        prefs.getString(_getCacheKey(_sessionCachePrefix, topic));
    if (jsonString == null) {
      return null;
    }
    final json = jsonDecode(jsonString);
    return Session.fromJson(json);
  }

  @override
  Future<void> setSession(Session session) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
        _getCacheKey(_sessionCachePrefix, session.topic), jsonEncode(session));
  }

  @override
  Future<void> removeSession(String topic) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_getCacheKey(_sessionCachePrefix, topic));
  }

  @override
  Future<Record?> getRecord(String topic) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_getCacheKey(_recordPrefix, topic));
    if (jsonString == null) {
      return null;
    }
    final json = jsonDecode(jsonString);
    return Record.fromJson(json);
  }

  @override
  Future<void> removeRecord(String topic) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_getCacheKey(_recordPrefix, topic));
  }

  @override
  Future<void> setRecord(Record record) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
        _getCacheKey(_recordPrefix, record.topic), jsonEncode(record));
  }

  @override
  Future<List<Session>> getAllSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final sessions = <Session>[];
    prefs.getKeys().forEach((key) {
      if (key.startsWith(_sessionCachePrefix)) {
        final value = prefs.getString(key);
        if (value != null) {
          final session = Session.fromJson(jsonDecode(value));
          sessions.add(session);
        }
      }
    });
    return sessions;
  }
}

///
abstract class KeyStorage {
  ///
  Future<String> get privateKeyHex;

  ///
  Future<void> savePrivateKey(String hexString);

  ///
  Future<void> reset();
}

///
class DappConnectKeyStorage extends KeyStorage {
  String? _privateKey;

  final _privateKeyStreamController = StreamController<String>.broadcast();

  Stream<String> get onPrivateKeyGenerated =>
      _privateKeyStreamController.stream;

  @override
  Future<String> get privateKeyHex async {
    final memoryPrivateKey = _privateKey;
    if (null != memoryPrivateKey) {
      return memoryPrivateKey;
    }
    // fetch private key from cache, if not found, generate a new one
    final privateKeyFromCache = await _fetchPrivateKeyFromCache();
    if (null != privateKeyFromCache) {
      _privateKey = privateKeyFromCache;
      return privateKeyFromCache;
    } else {
      final createdKeyPair = await KeyPair.generate();
      final privateKeyHex = createdKeyPair.privateKeyHex;
      _privateKeyStreamController.add(privateKeyHex);
      _privateKey = privateKeyHex;
      savePrivateKey(privateKeyHex);
      return privateKeyHex;
    }
  }

  @override
  Future<void> reset() async {
    _removePriateKeyFromCache();
  }

  @override
  Future<void> savePrivateKey(String hexString) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_cacheKey, hexString);
  }

  Future<void> _removePriateKeyFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_cacheKey);
  }

  Future<String?> _fetchPrivateKeyFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_cacheKey);
  }

  final String _cacheKey = 'com.web3mq.dappmq.private_key';
}
