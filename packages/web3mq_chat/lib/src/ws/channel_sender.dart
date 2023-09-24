import 'package:logging/logging.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'models/buffer_convertible.dart';

extension Sender on WebSocketChannel {
  ///
  void send(Web3MQBufferConvertible message) {
    Logger.root.info("sending message: $message");
    sink.add(message.toBuffer());
  }
}
