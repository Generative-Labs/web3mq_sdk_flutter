import 'participant.dart';
import 'response.dart';
import 'rpc_error.dart';
import 'session.dart';

///
class ResponseFactory {
  ///
  static Response createResponseByProposal(SessionProposal proposal,
      dynamic result, RPCError? error, String publicKey, Participant sender) {
    return Response(
        proposal.id, result, error, proposal.pairingTopic, publicKey, sender);
  }
}
