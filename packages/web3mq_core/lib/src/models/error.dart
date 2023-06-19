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
