import '../models/user.dart';
import '../models/wallet_connector.dart';

///
abstract class ExtraService {
  ///
  String get serviceId;

  ///
  void connect(User user, {WalletConnector? walletConnector});

  ///
  Future<Map<String, dynamic>?> fetchProfile(String didType, String didValue);

  ///
  Future<void> follow(String userId);

  ///
  Future<void> unfollow(String userId);
}
