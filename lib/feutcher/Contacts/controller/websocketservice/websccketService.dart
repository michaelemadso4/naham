import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  final String url;
  WebSocketChannel? _channel;

  WebSocketService(this.url);

  void connect() {
    _channel = WebSocketChannel.connect(Uri.parse(url));
  }

  void listen(Function(Map<String, dynamic>) onData) {
    _channel?.stream.listen((data) {
      final decodedData = jsonDecode(data) as Map<String, dynamic>;
      onData(decodedData);
    });
  }

  void send(String event, Map<String, dynamic> data) {
    final message = jsonEncode({
      'event': event,
      'data': data,
    });
    _channel?.sink.add(message);
  }

  void disconnect() {
    _channel?.sink.close();
  }
}
