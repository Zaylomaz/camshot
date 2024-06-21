import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart';

class AuthenticationService with ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  final FlutterSecureStorage storage = FlutterSecureStorage();

  Future<bool> login(String email, String password) async {
    if (!areCredentialsValid(email, password)) {
      print('Invalid email or password');
      return false;
    }
    var url = Uri.parse('http://dev.adsmap.kr.ua/api/auth/login');
    var response = await http.post(url as Uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      String Token = data['accessToken'] as String;
      await storage.write(key: "authToken", value: Token);
      notifyListeners();
      _isLoggedIn = true;
      return true;
    } else {
      print('Login Failed: ${response.body}');
      return false;
    }
  }

  Future<void> register(String firstName, String lastName, String email,
      String password, String phone, String cityId) async {
    var url = Uri.parse('http://dev.adsmap.kr.ua/api/auth/register');
    var response = await http.post(url, body: {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
      'phone': phone,
      'city_id': cityId,
    });

    if (response.statusCode == 200) {
      // ?????????? ???????? ???????????
      print('Registration Successful');
    } else {
      // ?????????? ??????
      print('Registration Failed: ${response.body}');
    }
  }

  void logout() async {
    _isLoggedIn = false;
    await storage.delete(key: "token");
    await storage.delete(key: "authToken");
    GoogleSignIn().signOut();
  }

  bool isEmailValid(String email) {
    return RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(email);
  }

  bool areCredentialsValid(String email, String password) {
    return isEmailValid(email) && password.isNotEmpty;
  }

  Future<bool> sendTokenToServer(String token) async {
    var url =
        Uri.parse('http://dev.adsmap.kr.ua/api/auth/google/login?token=$token');
    var response = await http.post(url);
    if (response.statusCode == 200) {
      return true;
    } else {
      print('Token validation failed: ${response.body}');
      return false;
    }
  }

  void validateGoogleToken(BuildContext context, String token) async {
    bool isValid = await sendTokenToServer(token);
    if (isValid) {
      _isLoggedIn = true;
      notifyListeners();
      Navigator.of(context).pushReplacementNamed('/mainScreen');
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Login Failed"),
          content: Text("Google token validation failed."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }
}
