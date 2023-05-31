import 'package:graphql/client.dart';
import 'package:web3mq/src/models/cyber_profile.dart';

///
class CyberProfileApi {
  /// Initialize a new cyber profile api
  CyberProfileApi(Link link) {
    _client = GraphQLClient(
      cache: GraphQLCache(),
      link: link,
    );
  }

  late final GraphQLClient _client;

  Future<CyberProfile?> getProfileByAddress(String address) async {
    final QueryOptions options = QueryOptions(
      document: gql(_getProfileByAddressQuery),
      variables: <String, dynamic>{'address': address},
    );
    final QueryResult result = await _client.query(options);
    if (result.hasException) {
      return null;
    }
    final profile = result.data?['address']['wallet']['primaryProfile']
        as Map<String, dynamic>?;
    if (null != profile) {
      return CyberProfile.fromJson(profile);
    } else {
      return null;
    }
  }

  final _getProfileByAddressQuery = r'''
query ProfileByAddress($address: AddressEVM!) {
    address(address: $address) {
      wallet {
        primaryProfile {
          id
          handle
          owner {
            address
            chainID
          }
          metadataInfo {
            avatar
            coverImage
          }
        }
      }
    }
  }
''';
}
