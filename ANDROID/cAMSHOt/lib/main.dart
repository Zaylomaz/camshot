// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: SignInDemo(),
//     );
//   }
// }
//
// class SignInDemo extends StatefulWidget {
//   @override
//   State createState() => SignInDemoState();
// }
//
// class SignInDemoState extends State<SignInDemo> {
//   GoogleSignIn _googleSignIn = GoogleSignIn(
//     scopes: [
//       'email',
//       'https://www.googleapis.com/auth/contacts.readonly',
//     ],
//   );
//
//   GoogleSignInAccount? _currentUser;
//
//   @override
//   void initState() {
//     super.initState();
//     _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
//       setState(() {
//         _currentUser = account;
//       });
//     });
//     _googleSignIn.signInSilently();
//   }
//
//   Future<void> _handleSignIn() async {
//     try {
//       await _googleSignIn.signIn();
//       GoogleSignInAuthentication googleAuth =
//           await _googleSignIn.currentUser!.authentication;
//       String? idToken = googleAuth.idToken;
//
//       if (idToken != null) {
//         await _sendTokenToBackend(idToken);
//       }
//     } catch (error) {
//       print(error);
//     }
//   }
//
//   Future<void> _sendTokenToBackend(String token) async {
//     final response = await http.post(
//       Uri.parse('http://your-api-endpoint.com/api/verify-token'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'token': token,
//       }),
//     );
//
//     if (response.statusCode == 200) {
//       // Обработка успешного ответа
//       print('Token verification successful');
//     } else {
//       // Обработка ошибки
//       print('Token verification failed');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Google Sign In Demo'),
//       ),
//       body: ConstrainedBox(
//         constraints: const BoxConstraints.expand(),
//         child: _buildBody(),
//       ),
//     );
//   }
//
//   Widget _buildBody() {
//     if (_currentUser != null) {
//       return Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           ListTile(
//             leading: GoogleUserCircleAvatar(
//               identity: _currentUser!,
//             ),
//             title: Text(_currentUser!.displayName ?? ''),
//             subtitle: Text(_currentUser!.email),
//           ),
//           const Text('Signed in successfully.'),
//           ElevatedButton(
//             child: const Text('SIGN OUT'),
//             onPressed: _handleSignOut,
//           ),
//           ElevatedButton(
//             child: const Text('REFRESH'),
//             onPressed: _handleSignIn,
//           ),
//         ],
//       );
//     } else {
//       return Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           const Text('You are not currently signed in.'),
//           ElevatedButton(
//             child: const Text('SIGN IN'),
//             onPressed: _handleSignIn,
//           ),
//         ],
//       );
//     }
//   }
//
//   Future<void> _handleSignOut() async {
//     _googleSignIn.disconnect();
//   }
// }
import 'package:camshot/config/app_routes.dart';
import 'package:camshot/src/screens/main_screen.dart';
import 'package:camshot/src/services/authentication_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:camshot/src/screens/login_screen.dart';
import 'package:camshot/src/screens/camera_screen.dart';
import 'package:provider/provider.dart';
import 'package:camshot/src/screens/registration_step_one.dart';
import 'package:camshot/src/screens/map_screen.dart';
import 'package:camshot/src/screens/profile_page_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider<AuthenticationService>(
      create: (_) => AuthenticationService(),
      child: MyApp(),
    ),
  );
  Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  final FlutterSecureStorage storage = FlutterSecureStorage();

  Future<Widget> getHomePage(BuildContext context) async {
    String? token = await storage.read(key: "authToken");
    if (token != null) {
      return MainScreen();
    } else {
      return LoginPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Camshot',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
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
        debugShowCheckedModeBanner: false,
        routes: {
          AppRoutes.login: (context) => LoginPage(),
          AppRoutes.registerStepOne: (context) => RegistrationStepOne(),
          // AppRoutes.registerStepTwo: (context) => RegistrationStepTwo(),
          AppRoutes.main: (context) => MainScreen(),
          AppRoutes.map: (context) => MapScreen(),
          AppRoutes.profile: (context) => ProfilePageScreen(),
          AppRoutes.camera: (context) => CameraScreen(),
        });
  }
}
