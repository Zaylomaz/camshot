import 'dart:io';
import 'package:http/http.dart' as http;

class HttpService {
  final String url;

  HttpService(this.url);

  Future<void> sendImage(String imagePath) async {
    try {
      final imageFile = File(imagePath);
      final imageExists = await imageFile.exists();

      if (!imageExists) {
        print('Image file does not exist at path: $imagePath');
        return;
      }
      final imageBytes = await imageFile.readAsBytes();
      print('Image file read successfully with size: ${imageBytes.length} bytes');
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/octet-stream"},
        body: imageBytes,
      );

      if (response.statusCode == 200) {
        print('Image uploaded successfully');
      } else {
        print('Image upload failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Failed to send image over HTTP: $e');
    }
  }
}