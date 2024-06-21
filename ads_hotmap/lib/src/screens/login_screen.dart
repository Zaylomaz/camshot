import 'package:flutter/material.dart';
import 'package:ads_hotmap/config/image_assets.dart';
import 'package:ads_hotmap/config/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ads_hotmap/src/services/http_service.dart';
import 'package:ads_hotmap/src/screens/main_screen.dart';
import 'package:ads_hotmap/src/screens/registration_step_one.dart';
import 'package:ads_hotmap/config/app_routes.dart';
import 'package:ads_hotmap/config/image_assets.dart';
import 'package:ads_hotmap/main.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final storage = FlutterSecureStorage();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  final serv = HttpService('http://dev.adsmap.kr.ua/api/auth/login');
  HttpService servG =
      HttpService('http://dev.adsmap.kr.ua/api/auth/firebase/login');

  Future<void> navigateToMain() async {
    Navigator.of(context).pushReplacementNamed(AppRoutes.main);
  }

  signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      var Token = await FirebaseAuth.instance.currentUser!.getIdToken();
      var token = await servG.firebaseLogin(Token!);

      // Получение user_id
      final String? userId = FirebaseAuth.instance.currentUser?.uid;

      // Установка user_id в Firebase Analytics
      await analytics.setUserId(id: userId);

      // Логирование события успешного входа через Google
      await analytics.logEvent(
        name: 'login',
        parameters: {
          'method': 'Google',
        },
      );

      navigateToMain();
    } catch (e) {
      print(e);
    }
  }

  void signIN({required String email, required String password}) async {
    try {
      var token = await serv.login(email, password);
      await storage.write(key: 'authToken', value: token);

      // Получение user_id
      final String? userId = FirebaseAuth.instance.currentUser?.uid;

      // Установка user_id в Firebase Analytics
      await analytics.setUserId(id: userId);

      // Логирование события успешного входа с использованием email и пароля
      await analytics.logEvent(
        name: 'login',
        parameters: {
          'method': 'email_password',
        },
      );

      navigateToMain();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(),
                Semantics(
                  label: 'Поле для ввода email',
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: "Email",
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    controller: emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Введите Email';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Semantics(
                  label: 'Поле для ввода пароля',
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: "Пароль",
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    controller: passwordController,
                    obscureText: true,
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: Semantics(
                    label: 'Кнопка входа',
                    child: ElevatedButton(
                      onPressed: () {
                        signIN(
                          email: emailController.text,
                          password: passwordController.text,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Войти"),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Spacer(),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 48,
                  child: Semantics(
                    label: 'Кнопка входа через Google',
                    child: ElevatedButton(
                      onPressed: () async {
                        signInWithGoogle();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(52)),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            AppImages.ic_google,
                            height: 22,
                            width: 22,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          const Text(
                            "Войти при помощи Google",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
