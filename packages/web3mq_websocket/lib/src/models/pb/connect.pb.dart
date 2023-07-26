///
//  Generated code. Do not modify.
//  source: connect.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

class ConnectCommand extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ConnectCommand',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'pb'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'nodeId',
        protoName: 'nodeId')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'userId',
        protoName: 'userId')
    ..a<$fixnum.Int64>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'timestamp',
        $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'msgSign',
        protoName: 'msgSign')
    ..hasRequiredFields = false;

  ConnectCommand._() : super();
  factory ConnectCommand({
    $core.String? nodeId,
    $core.String? userId,
    $fixnum.Int64? timestamp,
    $core.String? msgSign,
  }) {
    final _result = create();
    if (nodeId != null) {
      _result.nodeId = nodeId;
    }
    if (userId != null) {
      _result.userId = userId;
    }
    if (timestamp != null) {
      _result.timestamp = timestamp;
    }
    if (msgSign != null) {
      _result.msgSign = msgSign;
    }
    return _result;
  }
  factory ConnectCommand.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ConnectCommand.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ConnectCommand clone() => ConnectCommand()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ConnectCommand copyWith(void Function(ConnectCommand) updates) =>
      super.copyWith((message) => updates(message as ConnectCommand))
          as ConnectCommand; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ConnectCommand create() => ConnectCommand._();
  ConnectCommand createEmptyInstance() => create();
  static $pb.PbList<ConnectCommand> createRepeated() =>
      $pb.PbList<ConnectCommand>();
  @$core.pragma('dart2js:noInline')
  static ConnectCommand getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConnectCommand>(create);
  static ConnectCommand? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get nodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set nodeId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasNodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNodeId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get userId => $_getSZ(1);
  @$pb.TagNumber(2)
  set userId($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get timestamp => $_getI64(2);
  @$pb.TagNumber(3)
  set timestamp($fixnum.Int64 v) {
    $_setInt64(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasTimestamp() => $_has(2);
  @$pb.TagNumber(3)
  void clearTimestamp() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get msgSign => $_getSZ(3);
  @$pb.TagNumber(4)
  set msgSign($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasMsgSign() => $_has(3);
  @$pb.TagNumber(4)
  void clearMsgSign() => clearField(4);
}

class DisconnectCommand extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'DisconnectCommand',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'pb'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'nodeId',
        protoName: 'nodeId')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'userId',
        protoName: 'userId')
    ..a<$fixnum.Int64>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'timestamp',
        $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'msgSign',
        protoName: 'msgSign')
    ..hasRequiredFields = false;

  DisconnectCommand._() : super();
  factory DisconnectCommand({
    $core.String? nodeId,
    $core.String? userId,
    $fixnum.Int64? timestamp,
    $core.String? msgSign,
  }) {
    final _result = create();
    if (nodeId != null) {
      _result.nodeId = nodeId;
    }
    if (userId != null) {
      _result.userId = userId;
    }
    if (timestamp != null) {
      _result.timestamp = timestamp;
    }
    if (msgSign != null) {
      _result.msgSign = msgSign;
    }
    return _result;
  }
  factory DisconnectCommand.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DisconnectCommand.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DisconnectCommand clone() => DisconnectCommand()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DisconnectCommand copyWith(void Function(DisconnectCommand) updates) =>
      super.copyWith((message) => updates(message as DisconnectCommand))
          as DisconnectCommand; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DisconnectCommand create() => DisconnectCommand._();
  DisconnectCommand createEmptyInstance() => create();
  static $pb.PbList<DisconnectCommand> createRepeated() =>
      $pb.PbList<DisconnectCommand>();
  @$core.pragma('dart2js:noInline')
  static DisconnectCommand getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DisconnectCommand>(create);
  static DisconnectCommand? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get nodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set nodeId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasNodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNodeId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get userId => $_getSZ(1);
  @$pb.TagNumber(2)
  set userId($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get timestamp => $_getI64(2);
  @$pb.TagNumber(3)
  set timestamp($fixnum.Int64 v) {
    $_setInt64(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasTimestamp() => $_has(2);
  @$pb.TagNumber(3)
  void clearTimestamp() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get msgSign => $_getSZ(3);
  @$pb.TagNumber(4)
  set msgSign($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasMsgSign() => $_has(3);
  @$pb.TagNumber(4)
  void clearMsgSign() => clearField(4);
}

class UserTempConnectCommand extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'UserTempConnectCommand',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'pb'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'NodeID',
        protoName: 'NodeID')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'DAppID',
        protoName: 'DAppID')
    ..aOS(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'TopicID',
        protoName: 'TopicID')
    ..a<$fixnum.Int64>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'SignatureTimestamp',
        $pb.PbFieldType.OU6,
        protoName: 'SignatureTimestamp',
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'DAppSignature',
        protoName: 'DAppSignature')
    ..hasRequiredFields = false;

  UserTempConnectCommand._() : super();
  factory UserTempConnectCommand({
    $core.String? nodeID,
    $core.String? dAppID,
    $core.String? topicID,
    $fixnum.Int64? signatureTimestamp,
    $core.String? dAppSignature,
  }) {
    final _result = create();
    if (nodeID != null) {
      _result.nodeID = nodeID;
    }
    if (dAppID != null) {
      _result.dAppID = dAppID;
    }
    if (topicID != null) {
      _result.topicID = topicID;
    }
    if (signatureTimestamp != null) {
      _result.signatureTimestamp = signatureTimestamp;
    }
    if (dAppSignature != null) {
      _result.dAppSignature = dAppSignature;
    }
    return _result;
  }
  factory UserTempConnectCommand.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory UserTempConnectCommand.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  UserTempConnectCommand clone() =>
      UserTempConnectCommand()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  UserTempConnectCommand copyWith(
          void Function(UserTempConnectCommand) updates) =>
      super.copyWith((message) => updates(message as UserTempConnectCommand))
          as UserTempConnectCommand; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UserTempConnectCommand create() => UserTempConnectCommand._();
  UserTempConnectCommand createEmptyInstance() => create();
  static $pb.PbList<UserTempConnectCommand> createRepeated() =>
      $pb.PbList<UserTempConnectCommand>();
  @$core.pragma('dart2js:noInline')
  static UserTempConnectCommand getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UserTempConnectCommand>(create);
  static UserTempConnectCommand? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get nodeID => $_getSZ(0);
  @$pb.TagNumber(1)
  set nodeID($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasNodeID() => $_has(0);
  @$pb.TagNumber(1)
  void clearNodeID() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get dAppID => $_getSZ(1);
  @$pb.TagNumber(2)
  set dAppID($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasDAppID() => $_has(1);
  @$pb.TagNumber(2)
  void clearDAppID() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get topicID => $_getSZ(2);
  @$pb.TagNumber(3)
  set topicID($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasTopicID() => $_has(2);
  @$pb.TagNumber(3)
  void clearTopicID() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get signatureTimestamp => $_getI64(3);
  @$pb.TagNumber(4)
  set signatureTimestamp($fixnum.Int64 v) {
    $_setInt64(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasSignatureTimestamp() => $_has(3);
  @$pb.TagNumber(4)
  void clearSignatureTimestamp() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get dAppSignature => $_getSZ(4);
  @$pb.TagNumber(5)
  set dAppSignature($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasDAppSignature() => $_has(4);
  @$pb.TagNumber(5)
  void clearDAppSignature() => clearField(5);
}
