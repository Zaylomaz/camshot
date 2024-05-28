import 'package:flutter/material.dart';
import 'config/app_routes_old.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}
@override
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const storage = FlutterSecureStorage();

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