import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camshot/components/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../config/app_routes.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final cityController = TextEditingController();
  final dobController = TextEditingController(); // Дата рождения
  final fullNameController = TextEditingController();
  final passportDetailsController = TextEditingController();
  File? documentFile; // Для хранения выбранного файла

  Future<void> signUpWithEmailPassword() async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,);
      print("City: ${cityController.text}");
      print("Date of Birth: ${dobController.text}");
      print("Full Name: ${fullNameController.text}");
      print("Passport Details: ${passportDetailsController.text}");
      if (documentFile != null) {
        print("Document: ${documentFile!.path}");
      }
      Navigator.of(context).pushNamed(AppRoutes.main); // Перенаправление после успешной регистрации
    } catch (e) {
      print('Ошибка регистрации: $e');
    }
  }
  Future<void> pickDocument() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        documentFile = File(pickedFile.path);
      });
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
                AppTextField(
                  hint: "Электронная почта",
                  controllerName: emailController,
                ),
                const SizedBox(
                  height: 15,
                ),
                AppTextField(
                  hint: "Пароль",
                  controllerName: passwordController,
                ),
                const SizedBox(
                  height: 24,
                ),
                AppTextField(
                  hint: "Город",
                  controllerName: cityController,
                ),
                const SizedBox(height: 15),
                AppTextField(
                  hint: "Дата рождения",
                  controllerName: dobController,
                ),
                const SizedBox(height: 15),
                AppTextField(
                  hint: "ФИО",
                  controllerName: fullNameController,
                ),
                const SizedBox(height: 15),
                AppTextField(
                  hint: "Документ № (код пасспорта)",
                  controllerName: passportDetailsController,
                ),
                const SizedBox(height: 15),

                SizedBox(
                  width: 350,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => pickDocument(),
                    child: const Text("Загрузить документ"),
                  ),
                ),
                const Spacer(),
                const Spacer(),
                const Spacer(),
                SizedBox(
                  width: 400,
                  height: 60,

                  child: ElevatedButton(

                      onPressed: () async {
                        await signUpWithEmailPassword();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.grey[40],
                      ),

                      child: const Text("Зарегистрироваться")),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}