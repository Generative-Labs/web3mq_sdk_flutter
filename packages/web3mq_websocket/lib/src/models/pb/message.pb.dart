///
//  Generated code. Do not modify.
//  source: message.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

class Web3MQRequestMessage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'Web3MQRequestMessage',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'pb'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'payload',
        $pb.PbFieldType.OY)
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'contentTopic',
        protoName: 'contentTopic')
    ..a<$core.int>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'version',
        $pb.PbFieldType.OU3)
    ..aOS(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'comeFrom',
        protoName: 'comeFrom')
    ..aOS(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'fromSign',
        protoName: 'fromSign')
    ..aOS(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'payloadType',
        protoName: 'payloadType')
    ..aOS(
        7,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'cipherSuite',
        protoName: 'cipherSuite')
    ..aOB(
        8,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'needStore',
        protoName: 'needStore')
    ..a<$fixnum.Int64>(
        9,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'timestamp',
        $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(
        10,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'messageId',
        protoName: 'messageId')
    ..aOS(
        11,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'messageType',
        protoName: 'messageType')
    ..aOS(
        12,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'nodeId',
        protoName: 'nodeId')
    ..aOS(
        13,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'validatePubKey',
        protoName: 'validatePubKey')
    ..m<$core.String, $core.String>(
        14,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'extraData',
        protoName: 'extraData',
        entryClassName: 'Web3MQRequestMessage.ExtraDataEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('pb'))
    ..aOS(
        15,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'threadId',
        protoName: 'threadId')
    ..hasRequiredFields = false;

  Web3MQRequestMessage._() : super();
  factory Web3MQRequestMessage({
    $core.List<$core.int>? payload,
    $core.String? contentTopic,
    $core.int? version,
    $core.String? comeFrom,
    $core.String? fromSign,
    $core.String? payloadType,
    $core.String? cipherSuite,
    $core.bool? needStore,
    $fixnum.Int64? timestamp,
    $core.String? messageId,
    $core.String? messageType,
    $core.String? nodeId,
    $core.String? validatePubKey,
    $core.Map<$core.String, $core.String>? extraData,
    $core.String? threadId,
  }) {
    final _result = create();
    if (payload != null) {
      _result.payload = payload;
    }
    if (contentTopic != null) {
      _result.contentTopic = contentTopic;
    }
    if (version != null) {
      _result.version = version;
    }
    if (comeFrom != null) {
      _result.comeFrom = comeFrom;
    }
    if (fromSign != null) {
      _result.fromSign = fromSign;
    }
    if (payloadType != null) {
      _result.payloadType = payloadType;
    }
    if (cipherSuite != null) {
      _result.cipherSuite = cipherSuite;
    }
    if (needStore != null) {
      _result.needStore = needStore;
    }
    if (timestamp != null) {
      _result.timestamp = timestamp;
    }
    if (messageId != null) {
      _result.messageId = messageId;
    }
    if (messageType != null) {
      _result.messageType = messageType;
    }
    if (nodeId != null) {
      _result.nodeId = nodeId;
    }
    if (validatePubKey != null) {
      _result.validatePubKey = validatePubKey;
    }
    if (extraData != null) {
      _result.extraData.addAll(extraData);
    }
    if (threadId != null) {
      _result.threadId = threadId;
    }
    return _result;
  }
  factory Web3MQRequestMessage.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Web3MQRequestMessage.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Web3MQRequestMessage clone() =>
      Web3MQRequestMessage()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Web3MQRequestMessage copyWith(void Function(Web3MQRequestMessage) updates) =>
      super.copyWith((message) => updates(message as Web3MQRequestMessage))
          as Web3MQRequestMessage; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Web3MQRequestMessage create() => Web3MQRequestMessage._();
  Web3MQRequestMessage createEmptyInstance() => create();
  static $pb.PbList<Web3MQRequestMessage> createRepeated() =>
      $pb.PbList<Web3MQRequestMessage>();
  @$core.pragma('dart2js:noInline')
  static Web3MQRequestMessage getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Web3MQRequestMessage>(create);
  static Web3MQRequestMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get payload => $_getN(0);
  @$pb.TagNumber(1)
  set payload($core.List<$core.int> v) {
    $_setBytes(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasPayload() => $_has(0);
  @$pb.TagNumber(1)
  void clearPayload() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get contentTopic => $_getSZ(1);
  @$pb.TagNumber(2)
  set contentTopic($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasContentTopic() => $_has(1);
  @$pb.TagNumber(2)
  void clearContentTopic() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get version => $_getIZ(2);
  @$pb.TagNumber(3)
  set version($core.int v) {
    $_setUnsignedInt32(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearVersion() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get comeFrom => $_getSZ(3);
  @$pb.TagNumber(4)
  set comeFrom($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasComeFrom() => $_has(3);
  @$pb.TagNumber(4)
  void clearComeFrom() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get fromSign => $_getSZ(4);
  @$pb.TagNumber(5)
  set fromSign($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasFromSign() => $_has(4);
  @$pb.TagNumber(5)
  void clearFromSign() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get payloadType => $_getSZ(5);
  @$pb.TagNumber(6)
  set payloadType($core.String v) {
    $_setString(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasPayloadType() => $_has(5);
  @$pb.TagNumber(6)
  void clearPayloadType() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get cipherSuite => $_getSZ(6);
  @$pb.TagNumber(7)
  set cipherSuite($core.String v) {
    $_setString(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasCipherSuite() => $_has(6);
  @$pb.TagNumber(7)
  void clearCipherSuite() => clearField(7);

  @$pb.TagNumber(8)
  $core.bool get needStore => $_getBF(7);
  @$pb.TagNumber(8)
  set needStore($core.bool v) {
    $_setBool(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasNeedStore() => $_has(7);
  @$pb.TagNumber(8)
  void clearNeedStore() => clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get timestamp => $_getI64(8);
  @$pb.TagNumber(9)
  set timestamp($fixnum.Int64 v) {
    $_setInt64(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasTimestamp() => $_has(8);
  @$pb.TagNumber(9)
  void clearTimestamp() => clearField(9);

  @$pb.TagNumber(10)
  $core.String get messageId => $_getSZ(9);
  @$pb.TagNumber(10)
  set messageId($core.String v) {
    $_setString(9, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasMessageId() => $_has(9);
  @$pb.TagNumber(10)
  void clearMessageId() => clearField(10);

  @$pb.TagNumber(11)
  $core.String get messageType => $_getSZ(10);
  @$pb.TagNumber(11)
  set messageType($core.String v) {
    $_setString(10, v);
  }

  @$pb.TagNumber(11)
  $core.bool hasMessageType() => $_has(10);
  @$pb.TagNumber(11)
  void clearMessageType() => clearField(11);

  @$pb.TagNumber(12)
  $core.String get nodeId => $_getSZ(11);
  @$pb.TagNumber(12)
  set nodeId($core.String v) {
    $_setString(11, v);
  }

  @$pb.TagNumber(12)
  $core.bool hasNodeId() => $_has(11);
  @$pb.TagNumber(12)
  void clearNodeId() => clearField(12);

  @$pb.TagNumber(13)
  $core.String get validatePubKey => $_getSZ(12);
  @$pb.TagNumber(13)
  set validatePubKey($core.String v) {
    $_setString(12, v);
  }

  @$pb.TagNumber(13)
  $core.bool hasValidatePubKey() => $_has(12);
  @$pb.TagNumber(13)
  void clearValidatePubKey() => clearField(13);

  @$pb.TagNumber(14)
  $core.Map<$core.String, $core.String> get extraData => $_getMap(13);

  @$pb.TagNumber(15)
  $core.String get threadId => $_getSZ(14);
  @$pb.TagNumber(15)
  set threadId($core.String v) {
    $_setString(14, v);
  }

  @$pb.TagNumber(15)
  $core.bool hasThreadId() => $_has(14);
  @$pb.TagNumber(15)
  void clearThreadId() => clearField(15);
}

class Web3MQMessageStatusResp extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'Web3MQMessageStatusResp',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'pb'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'messageId',
        protoName: 'messageId')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'contentTopic',
        protoName: 'contentTopic')
    ..aOS(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'messageStatus',
        protoName: 'messageStatus')
    ..aOS(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'version')
    ..aOS(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'comeFrom',
        protoName: 'comeFrom')
    ..aOS(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'fromSign',
        protoName: 'fromSign')
    ..a<$fixnum.Int64>(
        7,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'timestamp',
        $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  Web3MQMessageStatusResp._() : super();
  factory Web3MQMessageStatusResp({
    $core.String? messageId,
    $core.String? contentTopic,
    $core.String? messageStatus,
    $core.String? version,
    $core.String? comeFrom,
    $core.String? fromSign,
    $fixnum.Int64? timestamp,
  }) {
    final _result = create();
    if (messageId != null) {
      _result.messageId = messageId;
    }
    if (contentTopic != null) {
      _result.contentTopic = contentTopic;
    }
    if (messageStatus != null) {
      _result.messageStatus = messageStatus;
    }
    if (version != null) {
      _result.version = version;
    }
    if (comeFrom != null) {
      _result.comeFrom = comeFrom;
    }
    if (fromSign != null) {
      _result.fromSign = fromSign;
    }
    if (timestamp != null) {
      _result.timestamp = timestamp;
    }
    return _result;
  }
  factory Web3MQMessageStatusResp.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Web3MQMessageStatusResp.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Web3MQMessageStatusResp clone() =>
      Web3MQMessageStatusResp()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Web3MQMessageStatusResp copyWith(
          void Function(Web3MQMessageStatusResp) updates) =>
      super.copyWith((message) => updates(message as Web3MQMessageStatusResp))
          as Web3MQMessageStatusResp; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Web3MQMessageStatusResp create() => Web3MQMessageStatusResp._();
  Web3MQMessageStatusResp createEmptyInstance() => create();
  static $pb.PbList<Web3MQMessageStatusResp> createRepeated() =>
      $pb.PbList<Web3MQMessageStatusResp>();
  @$core.pragma('dart2js:noInline')
  static Web3MQMessageStatusResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Web3MQMessageStatusResp>(create);
  static Web3MQMessageStatusResp? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get messageId => $_getSZ(0);
  @$pb.TagNumber(1)
  set messageId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasMessageId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessageId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get contentTopic => $_getSZ(1);
  @$pb.TagNumber(2)
  set contentTopic($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasContentTopic() => $_has(1);
  @$pb.TagNumber(2)
  void clearContentTopic() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get messageStatus => $_getSZ(2);
  @$pb.TagNumber(3)
  set messageStatus($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasMessageStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearMessageStatus() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get version => $_getSZ(3);
  @$pb.TagNumber(4)
  set version($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasVersion() => $_has(3);
  @$pb.TagNumber(4)
  void clearVersion() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get comeFrom => $_getSZ(4);
  @$pb.TagNumber(5)
  set comeFrom($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasComeFrom() => $_has(4);
  @$pb.TagNumber(5)
  void clearComeFrom() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get fromSign => $_getSZ(5);
  @$pb.TagNumber(6)
  set fromSign($core.String v) {
    $_setString(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasFromSign() => $_has(5);
  @$pb.TagNumber(6)
  void clearFromSign() => clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get timestamp => $_getI64(6);
  @$pb.TagNumber(7)
  set timestamp($fixnum.Int64 v) {
    $_setInt64(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasTimestamp() => $_has(6);
  @$pb.TagNumber(7)
  void clearTimestamp() => clearField(7);
}

class Web3MQChangeMessageStatus extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'Web3MQChangeMessageStatus',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'pb'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'messageId',
        protoName: 'messageId')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'contentTopic',
        protoName: 'contentTopic')
    ..aOS(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'messageStatus',
        protoName: 'messageStatus')
    ..aOS(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'version')
    ..aOS(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'comeFrom',
        protoName: 'comeFrom')
    ..aOS(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'fromSign',
        protoName: 'fromSign')
    ..a<$fixnum.Int64>(
        7,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'timestamp',
        $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  Web3MQChangeMessageStatus._() : super();
  factory Web3MQChangeMessageStatus({
    $core.String? messageId,
    $core.String? contentTopic,
    $core.String? messageStatus,
    $core.String? version,
    $core.String? comeFrom,
    $core.String? fromSign,
    $fixnum.Int64? timestamp,
  }) {
    final _result = create();
    if (messageId != null) {
      _result.messageId = messageId;
    }
    if (contentTopic != null) {
      _result.contentTopic = contentTopic;
    }
    if (messageStatus != null) {
      _result.messageStatus = messageStatus;
    }
    if (version != null) {
      _result.version = version;
    }
    if (comeFrom != null) {
      _result.comeFrom = comeFrom;
    }
    if (fromSign != null) {
      _result.fromSign = fromSign;
    }
    if (timestamp != null) {
      _result.timestamp = timestamp;
    }
    return _result;
  }
  factory Web3MQChangeMessageStatus.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Web3MQChangeMessageStatus.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Web3MQChangeMessageStatus clone() =>
      Web3MQChangeMessageStatus()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Web3MQChangeMessageStatus copyWith(
          void Function(Web3MQChangeMessageStatus) updates) =>
      super.copyWith((message) => updates(message as Web3MQChangeMessageStatus))
          as Web3MQChangeMessageStatus; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Web3MQChangeMessageStatus create() => Web3MQChangeMessageStatus._();
  Web3MQChangeMessageStatus createEmptyInstance() => create();
  static $pb.PbList<Web3MQChangeMessageStatus> createRepeated() =>
      $pb.PbList<Web3MQChangeMessageStatus>();
  @$core.pragma('dart2js:noInline')
  static Web3MQChangeMessageStatus getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Web3MQChangeMessageStatus>(create);
  static Web3MQChangeMessageStatus? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get messageId => $_getSZ(0);
  @$pb.TagNumber(1)
  set messageId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasMessageId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessageId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get contentTopic => $_getSZ(1);
  @$pb.TagNumber(2)
  set contentTopic($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasContentTopic() => $_has(1);
  @$pb.TagNumber(2)
  void clearContentTopic() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get messageStatus => $_getSZ(2);
  @$pb.TagNumber(3)
  set messageStatus($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasMessageStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearMessageStatus() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get version => $_getSZ(3);
  @$pb.TagNumber(4)
  set version($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasVersion() => $_has(3);
  @$pb.TagNumber(4)
  void clearVersion() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get comeFrom => $_getSZ(4);
  @$pb.TagNumber(5)
  set comeFrom($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasComeFrom() => $_has(4);
  @$pb.TagNumber(5)
  void clearComeFrom() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get fromSign => $_getSZ(5);
  @$pb.TagNumber(6)
  set fromSign($core.String v) {
    $_setString(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasFromSign() => $_has(5);
  @$pb.TagNumber(6)
  void clearFromSign() => clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get timestamp => $_getI64(6);
  @$pb.TagNumber(7)
  set timestamp($fixnum.Int64 v) {
    $_setInt64(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasTimestamp() => $_has(6);
  @$pb.TagNumber(7)
  void clearTimestamp() => clearField(7);
}

class MessageItem extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'MessageItem',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'pb'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'messageId',
        protoName: 'messageId')
    ..a<$core.int>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'version',
        $pb.PbFieldType.OU3)
    ..a<$core.List<$core.int>>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'payload',
        $pb.PbFieldType.OY)
    ..aOS(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'payloadType',
        protoName: 'payloadType')
    ..aOS(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'comeFrom',
        protoName: 'comeFrom')
    ..aOS(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'fromSign',
        protoName: 'fromSign')
    ..aOS(
        7,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'contentTopic',
        protoName: 'contentTopic')
    ..aOS(
        8,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'cipherSuite',
        protoName: 'cipherSuite')
    ..a<$fixnum.Int64>(
        9,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'timestamp',
        $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOB(
        10,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'read')
    ..a<$fixnum.Int64>(
        11,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'readTimestamp',
        $pb.PbFieldType.OU6,
        protoName: 'readTimestamp',
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  MessageItem._() : super();
  factory MessageItem({
    $core.String? messageId,
    $core.int? version,
    $core.List<$core.int>? payload,
    $core.String? payloadType,
    $core.String? comeFrom,
    $core.String? fromSign,
    $core.String? contentTopic,
    $core.String? cipherSuite,
    $fixnum.Int64? timestamp,
    $core.bool? read,
    $fixnum.Int64? readTimestamp,
  }) {
    final _result = create();
    if (messageId != null) {
      _result.messageId = messageId;
    }
    if (version != null) {
      _result.version = version;
    }
    if (payload != null) {
      _result.payload = payload;
    }
    if (payloadType != null) {
      _result.payloadType = payloadType;
    }
    if (comeFrom != null) {
      _result.comeFrom = comeFrom;
    }
    if (fromSign != null) {
      _result.fromSign = fromSign;
    }
    if (contentTopic != null) {
      _result.contentTopic = contentTopic;
    }
    if (cipherSuite != null) {
      _result.cipherSuite = cipherSuite;
    }
    if (timestamp != null) {
      _result.timestamp = timestamp;
    }
    if (read != null) {
      _result.read = read;
    }
    if (readTimestamp != null) {
      _result.readTimestamp = readTimestamp;
    }
    return _result;
  }
  factory MessageItem.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory MessageItem.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  MessageItem clone() => MessageItem()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  MessageItem copyWith(void Function(MessageItem) updates) =>
      super.copyWith((message) => updates(message as MessageItem))
          as MessageItem; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MessageItem create() => MessageItem._();
  MessageItem createEmptyInstance() => create();
  static $pb.PbList<MessageItem> createRepeated() => $pb.PbList<MessageItem>();
  @$core.pragma('dart2js:noInline')
  static MessageItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MessageItem>(create);
  static MessageItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get messageId => $_getSZ(0);
  @$pb.TagNumber(1)
  set messageId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasMessageId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessageId() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get version => $_getIZ(1);
  @$pb.TagNumber(2)
  set version($core.int v) {
    $_setUnsignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersion() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get payload => $_getN(2);
  @$pb.TagNumber(3)
  set payload($core.List<$core.int> v) {
    $_setBytes(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasPayload() => $_has(2);
  @$pb.TagNumber(3)
  void clearPayload() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get payloadType => $_getSZ(3);
  @$pb.TagNumber(4)
  set payloadType($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasPayloadType() => $_has(3);
  @$pb.TagNumber(4)
  void clearPayloadType() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get comeFrom => $_getSZ(4);
  @$pb.TagNumber(5)
  set comeFrom($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasComeFrom() => $_has(4);
  @$pb.TagNumber(5)
  void clearComeFrom() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get fromSign => $_getSZ(5);
  @$pb.TagNumber(6)
  set fromSign($core.String v) {
    $_setString(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasFromSign() => $_has(5);
  @$pb.TagNumber(6)
  void clearFromSign() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get contentTopic => $_getSZ(6);
  @$pb.TagNumber(7)
  set contentTopic($core.String v) {
    $_setString(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasContentTopic() => $_has(6);
  @$pb.TagNumber(7)
  void clearContentTopic() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get cipherSuite => $_getSZ(7);
  @$pb.TagNumber(8)
  set cipherSuite($core.String v) {
    $_setString(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasCipherSuite() => $_has(7);
  @$pb.TagNumber(8)
  void clearCipherSuite() => clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get timestamp => $_getI64(8);
  @$pb.TagNumber(9)
  set timestamp($fixnum.Int64 v) {
    $_setInt64(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasTimestamp() => $_has(8);
  @$pb.TagNumber(9)
  void clearTimestamp() => clearField(9);

  @$pb.TagNumber(10)
  $core.bool get read => $_getBF(9);
  @$pb.TagNumber(10)
  set read($core.bool v) {
    $_setBool(9, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasRead() => $_has(9);
  @$pb.TagNumber(10)
  void clearRead() => clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get readTimestamp => $_getI64(10);
  @$pb.TagNumber(11)
  set readTimestamp($fixnum.Int64 v) {
    $_setInt64(10, v);
  }

  @$pb.TagNumber(11)
  $core.bool hasReadTimestamp() => $_has(10);
  @$pb.TagNumber(11)
  void clearReadTimestamp() => clearField(11);
}

class Web3MQMessageListResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'Web3MQMessageListResponse',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'pb'),
      createEmptyInstance: create)
    ..pc<MessageItem>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'data',
        $pb.PbFieldType.PM,
        subBuilder: MessageItem.create)
    ..hasRequiredFields = false;

  Web3MQMessageListResponse._() : super();
  factory Web3MQMessageListResponse({
    $core.Iterable<MessageItem>? data,
  }) {
    final _result = create();
    if (data != null) {
      _result.data.addAll(data);
    }
    return _result;
  }
  factory Web3MQMessageListResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Web3MQMessageListResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Web3MQMessageListResponse clone() =>
      Web3MQMessageListResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Web3MQMessageListResponse copyWith(
          void Function(Web3MQMessageListResponse) updates) =>
      super.copyWith((message) => updates(message as Web3MQMessageListResponse))
          as Web3MQMessageListResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Web3MQMessageListResponse create() => Web3MQMessageListResponse._();
  Web3MQMessageListResponse createEmptyInstance() => create();
  static $pb.PbList<Web3MQMessageListResponse> createRepeated() =>
      $pb.PbList<Web3MQMessageListResponse>();
  @$core.pragma('dart2js:noInline')
  static Web3MQMessageListResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Web3MQMessageListResponse>(create);
  static Web3MQMessageListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<MessageItem> get data => $_getList(0);
}

class GetHistoryMessagesRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'GetHistoryMessagesRequest',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'pb'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'comeFrom',
        protoName: 'comeFrom')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'fromSign',
        protoName: 'fromSign')
    ..a<$core.int>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'version',
        $pb.PbFieldType.OU3)
    ..a<$fixnum.Int64>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'timestamp',
        $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  GetHistoryMessagesRequest._() : super();
  factory GetHistoryMessagesRequest({
    $core.String? comeFrom,
    $core.String? fromSign,
    $core.int? version,
    $fixnum.Int64? timestamp,
  }) {
    final _result = create();
    if (comeFrom != null) {
      _result.comeFrom = comeFrom;
    }
    if (fromSign != null) {
      _result.fromSign = fromSign;
    }
    if (version != null) {
      _result.version = version;
    }
    if (timestamp != null) {
      _result.timestamp = timestamp;
    }
    return _result;
  }
  factory GetHistoryMessagesRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GetHistoryMessagesRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  GetHistoryMessagesRequest clone() =>
      GetHistoryMessagesRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  GetHistoryMessagesRequest copyWith(
          void Function(GetHistoryMessagesRequest) updates) =>
      super.copyWith((message) => updates(message as GetHistoryMessagesRequest))
          as GetHistoryMessagesRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetHistoryMessagesRequest create() => GetHistoryMessagesRequest._();
  GetHistoryMessagesRequest createEmptyInstance() => create();
  static $pb.PbList<GetHistoryMessagesRequest> createRepeated() =>
      $pb.PbList<GetHistoryMessagesRequest>();
  @$core.pragma('dart2js:noInline')
  static GetHistoryMessagesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetHistoryMessagesRequest>(create);
  static GetHistoryMessagesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get comeFrom => $_getSZ(0);
  @$pb.TagNumber(1)
  set comeFrom($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasComeFrom() => $_has(0);
  @$pb.TagNumber(1)
  void clearComeFrom() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get fromSign => $_getSZ(1);
  @$pb.TagNumber(2)
  set fromSign($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasFromSign() => $_has(1);
  @$pb.TagNumber(2)
  void clearFromSign() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get version => $_getIZ(2);
  @$pb.TagNumber(3)
  set version($core.int v) {
    $_setUnsignedInt32(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearVersion() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get timestamp => $_getI64(3);
  @$pb.TagNumber(4)
  set timestamp($fixnum.Int64 v) {
    $_setInt64(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasTimestamp() => $_has(3);
  @$pb.TagNumber(4)
  void clearTimestamp() => clearField(4);
}
