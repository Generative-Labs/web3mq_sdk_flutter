import 'package:graphql/client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3mq/src/api/cyber_auth_api.dart';
import 'package:web3mq/src/api/cyber_connection_api.dart';
import 'package:web3mq/src/api/cyber_profile_api.dart';

abstract class CyberService {
  ///
  void connect(String userId);

  /// Api for auth.
  CyberAuthApi get auth;

  /// Api for profile.
  CyberProfileApi get profile;

  /// Api for connection.
  CyberConnectionApi get connection;

  ///
  Future<String?> fetchAccessToken();

  ///
  void saveAccessToken(String token);
}

/// a Cyber Service
class Web3MQCyberService extends CyberService {
  static final String _apiKey = 'g088Mb6LN2QYNhW0H2NDQTwtl5sZ7o8D';
  static final String _endpoint = 'https://api.cyberconnect.dev/testnet/';

  String? userId;

  String? accessToken;

  final HttpLink _defaultLink =
      HttpLink(_endpoint, defaultHeaders: {'X-API-KEY': _apiKey});

  Link? _link;

  Link get link => _link ??= _defaultLink;

  CyberAuthApi? _auth;

  CyberProfileApi? _profile;

  CyberConnectionApi? _connection;

  @override
  void connect(String userId) {
    this.userId = userId;
    fetchAccessToken().then((value) => _generateLinkByAccessToken(value));
  }

  /// Api for auth.
  @override
  CyberAuthApi get auth => _auth ??= CyberAuthApi(link);

  /// Api for profile.
  @override
  CyberProfileApi get profile => _profile ??= CyberProfileApi(link);

  /// Api for connection.
  @override
  CyberConnectionApi get connection => _connection ??= CyberConnectionApi(link);

  static final String _cacheKey = 'com.web3mq.cyber_token';

  String get _finalCacheKey {
    return _cacheKey + (userId ?? '');
  }

  @override
  Future<String?> fetchAccessToken() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(_finalCacheKey);
  }

  @override
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
}
