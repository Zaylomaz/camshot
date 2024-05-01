import 'package:flutter/material.dart';
import 'package:camshot/components/text_field.dart';
import 'package:camshot/config/image_assets.dart';
import 'package:camshot/config/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:camshot/pages/register_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:camshot/utils/http_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final storage = new FlutterSecureStorage();
  final serv = new HttpService('http://dev.adsmap.kr.ua/api/auth/login');

  Future<void> navigateToregister() async {
    Navigator.of(context).pushNamed(AppRoutes.register);
  }
  Future<void> navigateToMain()  async {
    Navigator.of(context).pushNamed(AppRoutes.main);
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  void signIN({required String email, required String password }) async {
    try{
      var token = await serv.login(email, password);
      await storage.write(key: 'authToken', value: token);
      navigateToMain();
    }
    catch (e) {
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
                    decoration:InputDecoration(hintText: "Email"),
                    controller: emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Введите Email';
                      }}),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  decoration:InputDecoration(hintText: "Пароль"),
                  controller: passwordController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Введите пароль';
                    }},
                ),
                const SizedBox(
                  height: 24,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: ElevatedButton(
                      onPressed: () {
                        signIN(email: emailController.text, password: passwordController.text);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.grey[40],
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
                          color: Colors.white60,
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
                        signIN(email: emailController.text, password: passwordController.text);
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
                                  color: Colors.white60,
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