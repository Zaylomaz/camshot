import 'package:flutter/material.dart';
import 'config/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final storage = FlutterSecureStorage();

    Future<String?> getToken() async {
      return await storage.read(key: 'authToken');
    }

    return MaterialApp(
      title: 'Camshot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Urbanist',
        scaffoldBackgroundColor: Colors.grey,
        brightness: Brightness.dark,
      ),
      initialRoute: getToken() != null ? AppRoutes.main : AppRoutes.login,
      routes: AppRoutes.pages,
    );
  }
}