import 'package:json_annotation/json_annotation.dart';

part 'accounts.g.dart';

@JsonSerializable()
class Account {
  final String namespace;
  final String reference;
  final String address;

  String get blockchainIdentifier {
    return '$namespace:$reference';
  }

  String get absoluteString {
    return '$namespace:$reference:$address';
  }

  Account(this.namespace, this.reference, this.address);

  Account.from(String string)
      : assert(CAIP10Helper.isConformsToCAIP10(string)),
        namespace = string.split(':')[0],
        reference = string.split(':')[1],
        address = string.split(':')[2];

  @override
  bool operator ==(other) {
    if (identical(this, other)) return true;
    return other is Account &&
        namespace == other.namespace &&
        reference == other.reference &&
        address == other.address;
  }

  @override
  int get hashCode =>
      address.hashCode ^ reference.hashCode ^ namespace.hashCode;

  /// Create a new instance from a json
  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$AccountToJson(this);
}

class CAIP10Helper {
  static final RegExp chainNamespaceRegex = RegExp(r'^[-a-z0-9]{3,8}$');
  static final RegExp chainReferenceRegex = RegExp(r'^[-a-zA-Z0-9]{1,32}$');
  static final RegExp accountAddressRegex = RegExp(r'^[a-zA-Z0-9]{1,64}$');

  static bool isConformsToCAIP10(String string) {
    final splits = string.split(':');
    if (splits.length != 3) {
      return false;
    }
    final namespace = splits[0];
    final reference = splits[1];
    final address = splits[2];
    final isNamespaceValid = chainNamespaceRegex.hasMatch(namespace);
    final isReferenceValid = chainReferenceRegex.hasMatch(reference);
    final isAddressValid = accountAddressRegex.hasMatch(address);
    return isNamespaceValid && isReferenceValid && isAddressValid;
  }

  /// Gets the wallet type of the given account.
  static String walletType(Account account) {
    switch (account.namespace) {
      case 'eip155':
        return 'eth';
      case 'SN_GOERLI':
        return 'starknet';
      default:
        return '';
    }
  }

  /// Gets the wallet type of the given account.
  static String walletTypeDescription(Account account) {
    switch (account.namespace) {
      case 'eipeth155':
        return 'Ethereum';
      case 'SN_GOERLI':
        return 'Starknet';
      default:
        return '';
    }
  }
}
