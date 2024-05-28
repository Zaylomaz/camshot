import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionManager {
  final storage = FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await storage.write(key: "token", value: token);
  }

  Future<String?> getToken() async {
    return await storage.read(key: "token");
  }

  Future<void> clearSession() async {
    await storage.deleteAll();
  }
}
