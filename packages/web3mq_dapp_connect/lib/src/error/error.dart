import 'package:equatable/equatable.dart';

/// Base error class.
class Web3MQError with EquatableMixin implements Exception {
  ///
  const Web3MQError(this.message);

  /// Error message
  final String message;

  @override
  String toString() => 'Web3MQError(message: $message)';

  @override
  List<Object?> get props => [message];
}

///
class DappConnectError extends Web3MQError {
  DappConnectError(super.message);

  /// Proposal not found.
  factory DappConnectError.proposalNotFound() {
    return DappConnectError("Proposal not found");
  }

  /// Session not found.
  factory DappConnectError.sessionNotFound() {
    return DappConnectError("Session not found");
  }

  /// Current user not found.
  factory DappConnectError.currentUserNotFound() {
    return DappConnectError("Current user not found");
  }

  /// Timeout.
  factory DappConnectError.timeout() {
    return DappConnectError('Timeout');
  }

  /// Unkonwn error.
  factory DappConnectError.unknown() {
    return DappConnectError('Unkonwn error');
  }
}
