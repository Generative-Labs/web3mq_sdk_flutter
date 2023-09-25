import 'package:json_annotation/json_annotation.dart';

import '../utils/form_data_converter.dart';
import 'participant.dart';
import 'rpc_request.dart';

part 'uri.g.dart';

///
@JsonSerializable(explicitToJson: true, includeIfNull: false, anyMap: true)
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

  /// Create a new instance from a url
  factory DappConnectURI.fromUrl(String url) {
    final json = FormDataConverter.convertFormDataStringToMap(url);
    print('debug:json: $json');
    print("debug:proposer:${json['proposer']}");
    if (json['proposer'] is Map<String, dynamic>) {
      print("debug:true");
    }
    return DappConnectURI.fromJson(json);
  }
}
