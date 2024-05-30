import 'package:flutter/material.dart';
import 'package:camshot/config/image_assets.dart';
import 'package:camshot/config/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:camshot/utils/http_service.dart';
import 'package:camshot/src/screens/main_screen.dart';
import 'package:camshot/src/screens/registration_step_one.dart';
import 'package:camshot/config/app_routes.dart';
import 'package:camshot/config/image_assets.dart';
import 'package:camshot/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  get storage => FlutterSecureStorage();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final serv = HttpService('http://dev.adsmap.kr.ua/api/auth/login');
  HttpService servG =
      HttpService('http://dev.adsmap.kr.ua/api/auth/firebase/login');

  Future<void> navigateToregister() async {
    Navigator.of(context).pushNamed(AppRoutes.registerStepOne);
  }

  Future<void> navigateToMain() async {
    Navigator.of(context).pushNamed(AppRoutes.main);
  }

  signInWithGoogle() async {
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
    navigateToMain();
  }

  void signIN({required String email, required String password}) async {
    try {
      var token = await serv.login(email, password);
      await storage.write(key: 'authToken', value: token);
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
                TextFormField(
                    decoration: const InputDecoration(hintText: "Email"),
                    controller: emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Введите Email';
                      }
                      return null;
                    }),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  decoration: const InputDecoration(hintText: "Пароль"),
                  controller: passwordController,
                  // validator: (value) {
                  //   if (value!.isEmpty) {
                  //     return 'Введите пароль';
                  //   }
                  //   return null;
                  // },
                ),
                const SizedBox(
                  height: 24,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: ElevatedButton(
                      onPressed: () {
                        signIN(
                            email: emailController.text,
                            password: passwordController.text);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Войти")),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: ElevatedButton(
                    onPressed: () async {
                      await navigateToregister();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        )),
                    child: const Text("Зарегистрироваться",
                        style: TextStyle(
                          color: Colors.white,
                        )),
                  ),
                ),
                const Spacer(),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                      onPressed: () {
                        signInWithGoogle();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(52)),
                          )),
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
                          const Text("Войти при помощи Google",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400)),
                        ],
                      )),
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
