import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ads_hotmap/src/models/faq.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FAQService {
  final String baseUrl = 'http://dev.adsmap.kr.ua/api/v1/faq';
  final storage = const FlutterSecureStorage();
  get token => storage.read(key: 'authToken');

  Future<List<FAQ>> fetchFAQs({int page = 1}) async {
    var response = await http.get(Uri.parse('$baseUrl/faq?page=$page'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data'] as List;
      return data.map((faq) => FAQ.fromJson(faq)).toList();
    } else {
      throw Exception('Failed to load FAQ');
    }
  }

  Future<FAQ> fetchFAQDetail(int id) async {
    var response = await http.get(Uri.parse('$baseUrl/$id'),
        headers: <String, String>{
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        });
    if (response.statusCode == 200) {
      var title = json.decode(response.body)['data']['title'];
      return FAQ(title: title, id: id);
    } else {
      throw Exception('Failed to load FAQ detail');
    }
  }

  Stream<List<dynamic>> fetchFaqSections() async* {
    final token = await storage.read(key: 'authToken');
    final response = await http.get(Uri.parse(baseUrl),
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
    }
  }

  Stream<String> fetchFaqContent(int id) async* {
    final token = await storage.read(key: 'authToken');
    final response =
        await http.get(Uri.parse('$baseUrl/$id'), headers: <String, String>{
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
      "charset": "UTF-8"
    });
    if (response.statusCode == 200) {
      var data = response.body;
      var content = jsonDecode(data)['data']['content'];
      yield content;
    }
  }
}
