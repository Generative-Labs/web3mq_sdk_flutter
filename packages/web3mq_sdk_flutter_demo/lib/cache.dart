import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3mq/web3mq.dart';
import 'package:web3mq_dapp_connect/dapp_connect.dart';

class CacheHelper {
  static const String _userIdKey = "_userIdKey";
  static const String _didTypeKey = "_didTypeKey";
  static const String _didValueKey = "_didValueKey";
  static const String _privateHexKey = "_privateHexKey";

  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_userIdKey, user.userId);
    prefs.setString(_didTypeKey, user.did.type);
    prefs.setString(_didValueKey, user.did.value);
    prefs.setString(_privateHexKey, user.sessionKey);
  }

  static Future<User?> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(_userIdKey);
    if (null == userId) {
      return Future.value(null);
    }
    final didType = prefs.getString(_didTypeKey);
    if (null == didType) {
      return Future.value(null);
    }
    final didValue = prefs.getString(_didValueKey);
    if (null == didValue) {
      return Future.value(null);
    }
    final privateKeyHex = prefs.getString(_privateHexKey);
    if (null == privateKeyHex) {
      return Future.value(null);
    }

    return User(userId, DID(didType, didValue), privateKeyHex);
  }
}
