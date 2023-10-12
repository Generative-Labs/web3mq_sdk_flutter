///
//  Generated code. Do not modify.
//  source: heartbeat.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

class WebsocketPingCommand extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'WebsocketPingCommand',
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

  WebsocketPingCommand._() : super();

  factory WebsocketPingCommand({
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

  factory WebsocketPingCommand.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);

  factory WebsocketPingCommand.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  WebsocketPingCommand clone() =>
      WebsocketPingCommand()..mergeFromMessage(this);

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  WebsocketPingCommand copyWith(void Function(WebsocketPingCommand) updates) =>
      super.copyWith((message) => updates(message as WebsocketPingCommand))
          as WebsocketPingCommand; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WebsocketPingCommand create() => WebsocketPingCommand._();

  WebsocketPingCommand createEmptyInstance() => create();

  static $pb.PbList<WebsocketPingCommand> createRepeated() =>
      $pb.PbList<WebsocketPingCommand>();

  @$core.pragma('dart2js:noInline')
  static WebsocketPingCommand getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WebsocketPingCommand>(create);
  static WebsocketPingCommand? _defaultInstance;

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

class WebsocketPongCommand extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'WebsocketPongCommand',
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

  WebsocketPongCommand._() : super();

  factory WebsocketPongCommand({
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

  factory WebsocketPongCommand.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);

  factory WebsocketPongCommand.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  WebsocketPongCommand clone() =>
      WebsocketPongCommand()..mergeFromMessage(this);

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  WebsocketPongCommand copyWith(void Function(WebsocketPongCommand) updates) =>
      super.copyWith((message) => updates(message as WebsocketPongCommand))
          as WebsocketPongCommand; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WebsocketPongCommand create() => WebsocketPongCommand._();

  WebsocketPongCommand createEmptyInstance() => create();

  static $pb.PbList<WebsocketPongCommand> createRepeated() =>
      $pb.PbList<WebsocketPongCommand>();

  @$core.pragma('dart2js:noInline')
  static WebsocketPongCommand getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WebsocketPongCommand>(create);
  static WebsocketPongCommand? _defaultInstance;

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
