import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  static const String baseUrl =
      'http://url.loc/api/v1'; // ??????? URL ?????? API

  // GET ?????? ??? ????????? ?????? FAQ
  static Future<Map<String, dynamic>> fetchFAQs(int page) async {
    var uri = Uri.parse('$baseUrl/faq?page=$page');

    try {
      var response = await http.get(uri, headers: {
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        return _handleError(response);
      }
    } catch (e) {
      throw Exception('Failed to connect to API: $e');
    }
  }

  // GET ?????? ??? ????????? ??????? ?????? FAQ ?? ID
  static Future<Map<String, dynamic>> fetchFAQDetail(int id) async {
    var uri = Uri.parse('$baseUrl/faq/$id');

    try {
      var response = await http.get(uri, headers: {
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        return _handleError(response);
      }
    } catch (e) {
      throw Exception('Failed to connect to API: $e');
    }
  }

  // ????????????? ?????????? ??????
  static Map<String, dynamic> _handleError(http.Response response) {
    if (response.statusCode == 401 || response.statusCode == 422) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Server error with status code: ${response.statusCode}');
    }
  }
}
