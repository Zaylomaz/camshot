import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class ApiService {

  final storage = const FlutterSecureStorage();

  final String baseUrl = 'http://dev.adsmap.kr.ua/api/v1/faq';

  Stream<List<dynamic>> fetchFaqSections() async* {
    final  token = await storage.read(key: 'authToken');
  final response = await http.get(
      Uri.parse(baseUrl),
      headers: <String, String>{
        "Authorization": "Bearer $token",
        "Content-Type": "text/html, charset=UTF-8"
      });
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['data'] != null && data['data'].isNotEmpty) {
        yield data['data'];
      } else {
        throw Exception("No sections found");
      }
    }}

  Stream<String> fetchFaqContent(int id) async* {
    final  token = await storage.read(key: 'authToken');
    final response = await http.get(Uri.parse('$baseUrl/$id'), headers: <String, String>{
    "Authorization": "Bearer $token",
    "Content-Type": "application/json"
    });
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      yield data['data']['content'];
    }
  }
}