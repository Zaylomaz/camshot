import 'dart:io';
// import 'package:ads_hotmap/src/pages/register_page.dart';
import 'package:ads_hotmap/src/services/background_service.dart';
import 'package:ads_hotmap/config/app_routes.dart';
import 'package:ads_hotmap/src/screens/main_screen.dart';
import 'package:ads_hotmap/src/services/authentication_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ads_hotmap/src/screens/login_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    await FirebaseAppCheck.instance.activate();
  } catch (e) {
    print('Error initializing Firebase: $e');
  }

  await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  await Workmanager().registerPeriodicTask(
    "uniqueName",
    "uploadTask",
    frequency: Duration(minutes: 20),
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
      title: 'ads_hotmap',
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
      return MainScreenWithPermission();
    } else {
      return LoginPage();
    }
  }
}

class MainScreenWithPermission extends StatefulWidget {
  @override
  _MainScreenWithPermissionState createState() =>
      _MainScreenWithPermissionState();
}

class _MainScreenWithPermissionState extends State<MainScreenWithPermission> {
  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    var status = await Permission.location.status;
    if (status.isDenied) {
      _showLocationPermissionDialog();
    } else if (status.isGranted) {
      // Разрешение уже предоставлено
    }
  }

  void _showLocationPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Разрешение на использование данных о местоположении'),
          content: Text(
              'Приложению необходимо ваше разрешение для доступа к данным о местоположении для предоставления точных сервисов.'),
          actions: <Widget>[
            TextButton(
              child: Text('Отклонить'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Разрешить'),
              onPressed: () async {
                Navigator.of(context).pop();
                var status = await Permission.location.request();
                if (status.isGranted) {
                } else {
                  // Разрешение отклонено
                  // Показываем сообщение пользователю или выполняем другую логику
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainScreen(); // Вернуть главный экран вашего приложения
  }
}
