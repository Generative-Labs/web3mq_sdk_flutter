import 'package:graphql/client.dart';

///
class CyberAuthApi {
  /// Initialize a new cyber auth api
  CyberAuthApi(Link link) {
    _client = GraphQLClient(
      cache: GraphQLCache(),
      link: link,
    );
  }

  late final GraphQLClient _client;

  ///
  Future<String> loginGetMessage(String domain, String address) async {
    final MutationOptions options = MutationOptions(
      document: gql(_loginGetMessageMutation),
      variables: <String, dynamic>{
        'domain': domain,
        'address': address,
      },
    );

    final QueryResult result = await _client.mutate(options);
    if (result.hasException) {
      throw result.exception!;
    }

    final String message = result.data?['loginGetMessage']['message'] as String;
    return message;
  }

  ///
  Future<String> loginVerify(
      String domain, String address, String signature) async {
    final MutationOptions options = MutationOptions(
      document: gql(_loginVerifyMutation),
      variables: <String, dynamic>{
        'domain': domain,
        'address': address,
        'signature': signature
      },
    );

    final QueryResult result = await _client.mutate(options);
    if (result.hasException) {
      throw result.exception!;
    }

    final String token = result.data?['loginVerify']['accessToken'] as String;
    return token;
  }

  final _loginVerifyMutation = r'''
mutation loginVerify($domain:String!,$address:AddressEVM!,$signature:String!) 
    {
      loginVerify(input:{
        domain:$domain,
        address:$address,
        signature:$signature
      }){
        accessToken
      }
    }
''';

  final _loginGetMessageMutation = r'''
mutation loginGetMessage($domain:String!,$address:AddressEVM!) {
      loginGetMessage(input:{
        domain: $domain,
        address: $address
      }) {
        message
      }
    }
  ''';
}
