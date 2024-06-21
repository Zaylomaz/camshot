import 'dart:io';
import 'package:camshot/pages/register_page.dart';
import 'package:camshot/src/services/background_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:camshot/config/app_routes.dart';
import 'package:camshot/src/screens/main_screen.dart';
import 'package:camshot/src/services/authentication_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:camshot/src/screens/login_screen.dart';
import 'package:camshot/src/screens/camera_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:camshot/src/screens/registration_step_one.dart';
import 'package:camshot/src/screens/map_screen.dart';
import 'package:camshot/src/screens/profile_page_screen.dart';
import 'package:intl/intl.dart';
import 'package:workmanager/workmanager.dart';
import 'package:http/http.dart' as http;
import 'config/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print('Error initializing Firebase: $e');
  }

  await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  await Workmanager().registerPeriodicTask(
    "uniqueName",
    "uploadTask",
    frequency: Duration(minutes: 1),
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthenticationService(),
      child: MyApp(),
    ),
  );
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case 'uploadTask':
        await BackgroundService.uploadPendingFiles();
        break;
    }
    return Future.value(true);
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camshot',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<Widget>(
        future: getHomePage(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return snapshot.data ?? LoginPage();
          } else {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
      routes: {
        AppRoutes.login: (context) => LoginPage(),
        AppRoutes.main: (context) => MainScreen(),
        // Добавьте остальные маршруты здесь
      },
    );
  }

  Future<Widget> getHomePage(BuildContext context) async {
    final storage = FlutterSecureStorage();
    String? token = await storage.read(key: "authToken");
    if (token != null) {
      return MainScreen();
    } else {
      return LoginPage();
    }
  }
}
