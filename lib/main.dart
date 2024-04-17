import 'package:flutter/material.dart';
import 'config/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:http_parser/http_parser.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:camera/camera.dart';
import 'pages/camera_screen.dart';
import 'pages/awsc_page.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    // This is the code that will be executed when the background task is triggered
    print("Background task executed");
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Workmanager().initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode: true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final connectivity = Connectivity().onConnectivityChanged.listen((results) {
    //   if (results.any((result) => result != ConnectivityResult.none)) {
    //     Workmanager().registerOneOffTask(
    //       'uploadImagesTask',
    //       'uploadImages',
    //     );
    //   }
    // });
    return MaterialApp(
      title: 'Camshot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'Urbanist',
          scaffoldBackgroundColor: Colors.grey,
          brightness: Brightness.dark,),
      initialRoute: AppRoutes.login,
      routes: AppRoutes.pages,
    );
  }
}


