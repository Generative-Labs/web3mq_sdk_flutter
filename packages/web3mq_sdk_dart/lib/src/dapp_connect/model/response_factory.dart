import 'package:web3mq/src/dapp_connect/model/response.dart';
import 'package:web3mq/src/dapp_connect/model/rpc_error.dart';
import 'package:web3mq/src/dapp_connect/model/session.dart';

///
class ResponseFactory {
  ///
  static Response createResponseByProposal(SessionProposal proposal,
      List<int>? result, RPCError? error, String publicKey) {
    return Response(
        proposal.id, result, error, proposal.pairingTopic, publicKey);
  }
}
