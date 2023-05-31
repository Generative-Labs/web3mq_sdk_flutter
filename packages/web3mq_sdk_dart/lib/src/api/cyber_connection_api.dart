import 'package:graphql/client.dart';

import '../models/cyber_user_follow_status.dart';

///
class CyberConnectionApi {
  /// Initialize a new cyber connection api
  CyberConnectionApi(Link link) {
    _client = GraphQLClient(
      cache: GraphQLCache(),
      link: link,
    );
  }

  late final GraphQLClient _client;

  ///
  Future<List<CyberFollowStatus>> batchAddressesFollowStatus(
      String me, List<String> addresses) async {
    final QueryOptions options = QueryOptions(
      document: gql(_batchAddressesFollowStatusQuery),
      variables: <String, dynamic>{'toAddrList': addresses, 'me': me},
    );
    final QueryResult result = await _client.query(options);
    if (result.hasException) {
      return [];
    }

    final items = result.data?["batchGetAddresses"] as List<dynamic>?;

    if (items is List<dynamic> && items.isNotEmpty) {
      List<CyberFollowStatus> results = [];
      for (var status in items) {
        final address = status['address'] as String?;
        final isFollowedByMe =
            status['wallet']?['primaryProfile']?['isFollowedByMe'] as bool?;
        if (address is String && isFollowedByMe is bool) {
          results.add(CyberFollowStatus(address, isFollowedByMe));
        }
      }
      return results;
    } else {
      return [];
    }
  }

  /// FOLLOW, UNFOLLOW
  Future<String> followGetMessage(
      String operation, String address, String handle) async {
    final MutationOptions options = MutationOptions(
      document: gql(_followMessageMutation),
      variables: <String, dynamic>{
        'operation': operation,
        'address': address,
        'handle': handle
      },
    );

    final QueryResult result = await _client.mutate(options);
    if (result.hasException) {
      throw result.exception!;
    }

    final String message =
        result.data?['createFollowTypedMessage']['message'] as String;
    return message;
  }

  /// SUCCESS
  /// INVALID_PARAMS
  /// HANDLE_NOT_FOUND
  /// INVALID_MESSAGE
  /// MESSAGE_EXPIRED
  /// INVALID_SIGNATURE
  /// RATE_LIMITED
  /// ALREADY_DONE
  /// EXPIRED_SIGNING_KEY
  Future<String> follow(String address, String handle, String signature,
      String signingKey) async {
    final MutationOptions options = MutationOptions(
      document: gql(_followMutation),
      variables: <String, dynamic>{
        'address': address,
        'handle': handle,
        'signature': signature,
        'signingKey': signingKey
      },
    );
    final QueryResult result = await _client.mutate(options);
    if (result.hasException) {
      throw result.exception!;
    }
    return result.data?['status'] as String;
  }

  ///
  Future<String> registerSigningKey(
      String address, String message, String signature, String appId) async {
    final MutationOptions options = MutationOptions(
      document: gql(_registerSigningKeyMutation),
      variables: <String, dynamic>{
        'address': address,
        'message': message,
        'signature': signature,
        'appId': appId
      },
    );
    final QueryResult result = await _client.mutate(options);
    if (result.hasException) {
      throw result.exception!;
    }
    return result.data?['status'] as String;
  }

  final String _followMutation = r'''
mutation Follow($address: AddressEVM!, $handle: String!, $message: String!, $signature: String!, $signingKey: String!) {
  follow(
    input: {address: $address, handle: $handle, message: $message, signature: $signature, signingKey: $signingKey}
  ) {
    status 
  }
}
''';

  final String _batchAddressesFollowStatusQuery = r'''
query BatchAddressesFollowStatus($me: AddressEVM!, $toAddrList: [AddressEVM!]!) {
  batchGetAddresses(addresses: $toAddrList) {
    address
    wallet {
      primaryProfile {
        isFollowedByMe(me: $me)
      }
    }
  }
}
''';

  final String _followMessageMutation = r''' 
query CreateFollowTypedMessage($operation:FollowOperation!,$address:AddressEVM!, $handle:String!) {
  createFollowTypedMessage(input: {
    address: $address,
    operation: $operation,
    handle: $handle
  }) {
    message
  }
}
  ''';

// address: String!
// address the user's address.

// message: String!
// message the generated message to be signed, including the signing key public key information.

// signature: String!
// signature the signature from signing the message.

// appId: String = ""

  final _registerSigningKeyMutation = r''' 
mutation RegisterSigningKey($address: String!, $message: String!, $signature: String!, $appId: String!) {
  registerSigningKey(
    input: {address: $address, message: $message, signature: $signature, appId: $appId}
  ) {
    status
  }
}
  ''';
}
