import 'package:json_annotation/json_annotation.dart';

import '../api/responses.dart';

part 'channel_state.g.dart';

/// The class that contains the information about a channel
@JsonSerializable()
class ChannelState {
  /// The channel to which this state belongs
  final ChannelModel channel;

  /// A paginated list of channel messages
  final List<Message> messages;

  /// A paginated list of channel members
  final List<Member>? members;

  /// The last message in the channel
  Message? get lastMessage =>
      messages.isNotEmpty == true ? messages.last : null;

  /// Create a new instance from a json
  static ChannelState fromJson(Map<String, dynamic> json) =>
      _$ChannelStateFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$ChannelStateToJson(this);

  /// Creates a copy of [ChannelState] with specified attributes overridden.
  ChannelState copyWith(
          {ChannelModel? channel,
          List<Message>? messages,
          List<Member>? members}) =>
      ChannelState(
          channel: channel ?? this.channel,
          messages: messages ?? this.messages,
          members: members ?? this.members);

  /// Constructor used for json serialization
  ChannelState({required this.channel, required this.messages, this.members});
}
