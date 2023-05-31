import 'package:test/test.dart';
import 'package:web3mq/src/dapp_connect/model/app_metadata.dart';
import 'package:web3mq/src/dapp_connect/model/namespace.dart';
import 'package:web3mq/src/dapp_connect/model/participant.dart';
import 'package:web3mq/src/dapp_connect/model/rpc_request.dart';
import 'package:web3mq/src/dapp_connect/model/session.dart';
import 'package:web3mq/src/dapp_connect/model/uri.dart';

void main() {
  group('A group of uri tests', () {
    test('uri generation should be right', () async {
      //
      final sessionProposal = SessionProposalContent({
        'ProposalNamespaceAccountId':
            ProposalNamespace({''}, {'personal_sign'}, {''})
      }, SessionProperties('expiry'));

      final uri = DappConnectURI(
          'topic',
          Participant(
              'publicKey',
              AppMetadata('name', 'description', 'url', ['icon0', 'icon1'],
                  'redirect_url')),
          SessionProposalRPCRequest(
            'id',
            'method',
            sessionProposal,
          ));

      print('debug:result:${uri.absoluteString}');
    });
  });
}
