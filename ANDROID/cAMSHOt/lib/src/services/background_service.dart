import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class BackgroundService {
  static final FlutterSecureStorage storage = FlutterSecureStorage();

  static Future<void> uploadPendingFiles() async {
    final token = await storage.read(key: "authToken");
    if (token == null) return;

    final dir = await getApplicationDocumentsDirectory();
    final dirPath = "${dir.path}/Pictures";
    final files = Directory(dirPath).listSync();

    for (var file in files) {
      if (file is File && file.path.endsWith('.jpg')) {
        final fileName = file.path.split('/').last;
        final parts = fileName.split('|');

        if (parts.length == 3) {
          final timestamp = int.parse(parts[0]);
          final latitude = parts[1];
          final longitude = parts[2].replaceAll('.jpg', '');
          final DateTime createdAt =
              DateTime.fromMillisecondsSinceEpoch(timestamp);

          final request = http.MultipartRequest(
              'POST', Uri.parse('https://dev.adsmap.kr.ua/api/v1/reports'));
          request.fields['latitude'] = latitude;
          request.fields['longitude'] = longitude;
          request.fields['created_at'] =
              DateFormat('yyyy-MM-dd HH:mm:ss').format(createdAt);
          request.files
              .add(await http.MultipartFile.fromPath('photo', file.path));

          request.headers.addAll({
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json; charset=UTF-8',
          });

          final streamedResponse = await request.send();
          final response = await http.Response.fromStream(streamedResponse);

          if (response.statusCode == 201) {
            file.deleteSync();
          } else {
            print('Failed to upload file: ${response.body}');
          }
        }
      }
    }
    if (files.isEmpty) {
      WidgetBuilder builder = (BuildContext context) {
        return AlertDialog(
          title: Text('No pending files'),
          content: Text('There are no pending files to upload.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      };
    }
  }
}
