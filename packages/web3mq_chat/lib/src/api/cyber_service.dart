import 'dart:convert';
import 'package:cryptography/cryptography.dart' as cry;
import 'package:convert/convert.dart';
import 'package:graphql/client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3mq/src/api/cyber_auth_api.dart';
import 'package:web3mq/src/api/cyber_connection_api.dart';
import 'package:web3mq/src/api/cyber_profile_api.dart';
import 'package:web3mq/src/api/extra_service.dart';
import '../error/error.dart';
import '../models/models.dart';
import '../utils/cyber_signing_key_storage.dart';

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

/// a Cyber Service
class Web3MQCyberService extends ExtraService {
  static final String _apiKey = 'g088Mb6LN2QYNhW0H2NDQTwtl5sZ7o8D';
  static final String _endpoint = 'https://api.cyberconnect.dev/testnet/';

  User? user;

  WalletConnector? walletConnector;

  String? accessToken;

  final HttpLink _defaultLink =
      HttpLink(_endpoint, defaultHeaders: {'X-API-KEY': _apiKey});

  Link? _link;

  Link get link => _link ??= _defaultLink;

  CyberAuthApi? _auth;

  CyberProfileApi? _profile;

  CyberConnectionApi? _connection;

  @override
  void connect(User user, {WalletConnector? walletConnector}) {
    this.user = user;
    this.walletConnector = walletConnector;
    fetchAccessToken().then((value) => _generateLinkByAccessToken(value));
  }

  /// Api for auth.
  CyberAuthApi get auth => _auth ??= CyberAuthApi(link);

  /// Api for profile.
  CyberProfileApi get profile => _profile ??= CyberProfileApi(link);

  /// Api for connection.
  CyberConnectionApi get connection => _connection ??= CyberConnectionApi(link);

  static final String _cacheKey = 'com.web3mq.cyber_token';

  String get _finalCacheKey {
    return _cacheKey + (user?.userId ?? '');
  }

  Future<String?> fetchAccessToken() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(_finalCacheKey);
  }

  void saveAccessToken(String token) async {
    _generateLinkByAccessToken(token);
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(_finalCacheKey, token);
  }

  void _updateLink(Link link) {
    _link = link;
    _auth = CyberAuthApi(link);
    _profile = CyberProfileApi(link);
    _connection = CyberConnectionApi(link);
  }

  void _generateLinkByAccessToken(String? accessToken) {
    final httpLink =
        HttpLink(_endpoint, defaultHeaders: {'X-API-KEY': _apiKey});
    if (null != accessToken) {
      final authLink = AuthLink(
        getToken: () async => 'bearer $accessToken',
      );
      _link = authLink.concat(httpLink);
    } else {
      _link = httpLink;
    }
    _updateLink(_link!);
  }

  ///
  Future<String?> _authCyberIfNeeded(
      String address, WalletConnector walletConnector) async {
    final currentAccessToken = await fetchAccessToken();
    if (null != currentAccessToken) {
      return currentAccessToken;
    }

    final domain = 'web3mq.com';
    // final address = state.currentUser!.did.value;

    final message = await auth.loginGetMessage(domain, address);
    final signature = await walletConnector.personalSign(message, address);
    final token = await auth.loginVerify(domain, address, signature);

    // persistence token
    saveAccessToken(token);

    return token;
  }

  @override
  String get serviceId => "com.cyber.api";

  @override
  Future<Map<String, dynamic>?> fetchProfile(
      String didType, String didValue) async {
    if (null == user) {
      throw Web3MQError('User did not setup');
    }
    final userInfo = await profile.getProfileByAddress(didValue);
    return userInfo?.toJson();
  }

  @override
  Future<void> follow(String userId) {
    if (null == user) {
      throw Web3MQError('User did not setup');
    }

    if (null == walletConnector) {
      throw Web3MQError('WalletConnector did not setup');
    }

    return _doCyberFollow(
        walletConnector!, CyberFollowOperation.follow, userId);
  }

  @override
  Future<void> unfollow(String userId) {
    if (null == user) {
      throw Web3MQError('User did not setup');
    }

    if (null == walletConnector) {
      throw Web3MQError('WalletConnector did not setup');
    }

    return _doCyberFollow(
        walletConnector!, CyberFollowOperation.unfollow, userId);
  }

  Future<String> _doCyberFollow(WalletConnector walletConnector,
      CyberFollowOperation operation, String targetAddress) async {
    final user = await profile.getProfileByAddress(targetAddress);

    if (null == user || user.handle.isEmpty) {
      throw Web3MQContactsError.cyberUserNotFound;
    }

    final signingKey = await registerCyberSigningKey();

    final address = this.user?.did.value ?? '';
    final handle = user.handle;
    final message =
        await connection.followGetMessage(operation.value, address, handle);

    final signature = await walletConnector.personalSign(message, address);
    return await connection.follow(address, user.handle, signature, signingKey);
  }

  /// Register cyber signing key
  Future<String> registerCyberSigningKey() async {
    if (null == user) {
      throw Web3MQError('User did not setup');
    }

    if (null == walletConnector) {
      throw Web3MQError('WalletConnector did not setup');
    }

    await _authCyberIfNeeded(user!.did.value, walletConnector!);
    final address = user!.did.value;

    final storage = CyberSigningKeyStorage();
    final hasKey = await storage.hasSigningKeyByAddress(address);
    if (hasKey) {
      return await storage.getSigningKeyByAddress(address);
    }

    final privateKey = await storage.getSigningKeyByAddress(address);
    final keyPair =
        await cry.Ed25519().newKeyPairFromSeed(hex.decode(privateKey));
    final publicKey = await keyPair.extractPublicKey();
    final publicKeyHex = hex.encode(publicKey.bytes);

    final acknowledgement =
        '''
I authorize CyberConnect from this device using signing key:
''';

    final message = '$acknowledgement$publicKeyHex';
    final signature =
        await cry.Ed25519().sign(utf8.encode(message), keyPair: keyPair);
    final signatureHex = hex.encode(signature.bytes);

    final status = await connection.registerSigningKey(
        address, message, signatureHex, _apiKey);
    if ('SUCCESS' == status) {
      // persistence key
      storage.setSigningKeyByAddress(address, privateKey);
    } else {
      throw Web3MQError('Register cyber signing key failed: $status');
    }
    return privateKey;
  }
}
