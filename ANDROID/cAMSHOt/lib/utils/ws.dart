import 'dart:io';
import 'package:web_socket_channel/io.dart';
import 'package:path_provider/path_provider.dart';

class WebSocketService {
  final String url;
  IOWebSocketChannel channel;
  Stream<dynamic> broadcastStream;

  WebSocketService(this.url)
      : channel = IOWebSocketChannel.connect(url),
        broadcastStream = IOWebSocketChannel.connect(url).stream.asBroadcastStream() {
    print('WebSocket connection established');
    broadcastStream.listen((message) {
      print('Received message: $message');
    }, onError: (error) {
      print('Error in WebSocket connection: $error');
    });
  }

  void sendImage(String imagePath) async {
    try {
      final imageBytes = await File(imagePath).readAsBytes();
      channel.sink.add(imageBytes);
      print('Image sent over WebSocket');
    } catch (e) {
      print('Failed to send image over WebSocket: $e');
    }
  }

  Future<void> sendAllImages() async {
    final directory = await getApplicationDocumentsDirectory();
    final imageFiles = directory.listSync().where((file) => file.path.endsWith('.jpeg')).toList();

    for (var imageFile in imageFiles) {
      try {
        final imageBytes = await File(imageFile.path).readAsBytes();
        channel.sink.add(imageBytes);
        print('Image${imageFile.path} sent over WebSocket');
        imageFile.delete();
        // Wait for the server to respond
        final serverResponse = await broadcastStream.first;
        // If the server responds with a status code of 200, delete the image file
        if (serverResponse) {
          print('Image file deleted: ${imageFile.path}');
        }
      } catch (e) {
        print('Failed to send image over WebSocket: $e');
        close();
      }
    }
  }

  Future<void> close() async {
    await channel.sink.close();
    print('WebSocket connection closed');
  }
}