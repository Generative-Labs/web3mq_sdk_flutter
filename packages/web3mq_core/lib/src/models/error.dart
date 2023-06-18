/// Base error class.
class Web3MQError implements Exception {
  ///
  const Web3MQError(this.message);

  /// Error message
  final String message;

  @override
  String toString() => 'Web3MQError(message: $message)';
}
