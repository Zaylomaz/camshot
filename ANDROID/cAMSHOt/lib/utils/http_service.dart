import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class HttpService {
  final String url;

  var responseBody;

  HttpService(this.url);

  var storage = const FlutterSecureStorage();

  Future<void> sendImage(String imagePath) async {
    try {
      final imageFile = File(imagePath);
      final imageExists = await imageFile.exists();

      if (!imageExists) {
        print('Image file does not exist at path: $imagePath');
        return;
      }
      final imageBytes = await imageFile.readAsBytes();
      print(
          'Image file read successfully with size: ${imageBytes.length} bytes');
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

  Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final String token = responseBody['accessToken'];
      return token;
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<String> getProfileData() async {
    final token = storage.read(key: 'accessToken');
    var response = await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
      'Content-Type': 'application/json; charset=UTF-8',
    });
    return response.body;
  }
}
