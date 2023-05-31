///
enum ConnectionStatus {
  /// websocket is connected.
  connected,

  /// websocket is connecting (usually reconnecting).
  connecting,

  /// websocket is disconnected and it's not reconnecting.
  disconnected,
}
