import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

class SocketService {
  late Socket socket;
  final StreamController<String> messageController =
      StreamController<String>.broadcast();
  final StreamController<Uint8List> recordController =
      StreamController<Uint8List>.broadcast();

  Stream<String> get messages => messageController.stream;
  Stream<Uint8List> get record => recordController.stream;

  Future<void> connect(String address, int port) async {
    socket = await Socket.connect(address, port);
    print('Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');

    /*socket.listen(
      (data) {
        final message = String.fromCharCodes(data);
        // print('Received: $message');
        recordController.add(data);
        // messageController.add(message);
      },
      onError: (error) {
        print('Error: $error');
        socket.destroy();
      },
      onDone: () {
        print('Server closed the connection');
        socket.destroy();
      },
    );*/
  }

  void sendRecord(Stream<Uint8List> audioStream) {
    audioStream.listen((data) {
      // Sending each chunk of audio data to the socket
      socket.add(data);
    }, onError: (error) {
      print('Error sending audio data: $error');
    }, onDone: () {
      print('Finished sending audio data');
    });
  }

  void sendrecord(fileBytes){
    socket.write(fileBytes);
  }
  void sendMessage(String message) {
    socket.write(message);
  }

  void closeConnection() {
    socket.close();
    messageController.close();
    recordController.close();
  }
}
