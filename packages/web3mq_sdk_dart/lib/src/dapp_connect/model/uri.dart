import 'package:json_annotation/json_annotation.dart';
import 'package:web3mq/src/dapp_connect/model/participant.dart';
import 'package:web3mq/src/dapp_connect/utils/form_data_converter.dart';

import 'rpc_request.dart';

part 'uri.g.dart';

///
@JsonSerializable(explicitToJson: true)
class DappConnectURI {
  final String topic;

  ///
  final Participant proposer;

  ///
  final SessionProposalRPCRequest request;

  ///
  String get absoluteString {
    return FormDataConverter.convertJsonToFormData(toJson());
  }

  ///
  Uri get deepLinkURL => Uri.parse('web3mq://?$absoluteString');

  ///
  DappConnectURI(this.topic, this.proposer, this.request);

  /// Create a new instance from a json
  factory DappConnectURI.fromJson(Map<String, dynamic> json) =>
      _$DappConnectURIFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$DappConnectURIToJson(this);
}
