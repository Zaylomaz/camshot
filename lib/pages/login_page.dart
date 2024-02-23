import 'package:flutter/material.dart';
import 'package:camshot/components/text_field.dart';
import 'package:camshot/config/image_assets.dart';
import 'package:camshot/config/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();


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
                  hint: "Username",
                  controllerName: usernameController,
                ),
                const SizedBox(
                  height: 15,
                ),
                AppTextField(
                  hint: "Password",
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
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                      ),
                      child: const Text("Login")),
                ),
                const Spacer(),
                const Text(
                  "Or sign in with",
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
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
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
                          const Text(" Login with Google"),
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