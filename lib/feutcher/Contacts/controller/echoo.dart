import 'websocketservice/websccketService.dart';

class Echo {
  final WebSocketService _webSocketService;
  Echo(String url) : _webSocketService = WebSocketService(url);
  void connect() {
    _webSocketService.connect();
  }
  void channel(String channelName, Function(Map<String, dynamic>) onData) {
    _webSocketService.listen((data) {
      if (data['channel'] == channelName) {
        onData(data['data']);
      }
    });
  }
  void privateChannel(String channelName, Function(Map<String, dynamic>) onData) {
    channel('private-$channelName', onData);
  }
  void presenceChannel(String channelName, Function(Map<String, dynamic>) onData) {
    channel('presence-$channelName', onData);
  }
  void disconnect() {
    _webSocketService.disconnect();
  }
}