import 'package:flutter/material.dart';
import 'package:camshot/components/text_field.dart';
import 'package:camshot/config/image_assets.dart';
import 'package:camshot/config/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:camshot/pages/signUP_page.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();

  Future<void> navigateToSignUp() async {
    Navigator.of(context).pushNamed(AppRoutes.signUp); // Убедитесь, что вы добавили маршрут в AppRoutes
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
  Future<void> signIN() async {
    if(signInWithGoogle().then((value) => value.user) != null)
    {
      Navigator.of(context).pushNamed(AppRoutes.main);
    }
    else{
      print('<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<Ошибка входа через Google:'
      );};

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
                AppTextField(
                  hint: "Логин",
                  controllerName: usernameController,
                ),
                const SizedBox(
                  height: 15,
                ),
                AppTextField(
                  hint: "Пароль",
                  controllerName: emailController,
                ),
                const SizedBox(
                  height: 24,
                ),
                SizedBox(
                  width: 250,
                  child: ElevatedButton(
                      onPressed: () async {
                        await signIN();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.grey[40],
                      ),
                      child: const Text("Войти")),
                ),
                SizedBox(
                  width: 250,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () async {
                      await navigateToSignUp();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                        )),
                    child: const Text("Зарегистрироваться",
                        style: TextStyle(
                            color: Colors.white60,),
                ),
                ),
                ),
                const Spacer(),
                const Text(
                  "Войти с помощью:",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                      onPressed: () async {
                        await signIN();
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
                          const Text(" Войти при помощи Google",
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