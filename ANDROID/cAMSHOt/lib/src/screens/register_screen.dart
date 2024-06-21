// import 'dart:convert';
//
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:camshot/components/text_field.dart';
// import 'package:camshot/config/app_routes.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//
// class RegisterPage extends StatefulWidget {
//   const RegisterPage({super.key});
//
//   @override
//   State<RegisterPage> createState() => _RegisterPageState();
// }
//
// class _RegisterPageState extends State<RegisterPage> {
//   final first_nameController = TextEditingController();
//   final last_nameController = TextEditingController();
//   final middle_nameController = TextEditingController();
//   final phoneController = TextEditingController();
//   final cityController = TextEditingController();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final storage = const FlutterSecureStorage();
//   String? selectedCity;
//   Future<Map<String, String>>? cities;
//
//   @override
//   void initState() {
//     super.initState();
//     cities = getCities() as Future<Map<String, String>>?;
//   }
//
//   Future<Map<String, String>> getCities() async {
//     final response = await http
//         .get(Uri.parse('http://dev.adsmap.kr.ua/api/v1/dictionary/public'));
//     Map<String, dynamic> responseMap =
//         jsonDecode(response.body)['cities'] as Map<String, dynamic>;
//     return responseMap.map((key, value) => MapEntry(key, value.toString()));
//   }
//
//   Future<void> register() async {
//     final uri = await http.post(
//       Uri.parse('http://dev.adsmap.kr.ua/api/auth/register'),
//       headers: <String, String>{'Content-Type': 'application/json'},
//       body: jsonEncode(<String, String>{
//         'email': emailController.text,
//         'password': passwordController.text,
//         'first_name': first_nameController.text,
//         'last_name': last_nameController.text,
//         'middle_name': middle_nameController.text,
//         'phone': phoneController.text,
//         'city_id': cityController.text,
//       }),
//     );
//
//     if (uri.statusCode == 200) {
//       var responseBody = jsonDecode(uri.body);
//       storage.write(key: 'authToken', value: responseBody["accessToken"]);
//       Navigator.of(context).pushNamed(AppRoutes.login);
//     } else {
//       throw Exception('Failed to register');
//     }
//   }
//
//   @override
//   void dispose() {
//     emailController.dispose();
//     passwordController.dispose();
//     cityController.dispose();
//     phoneController.dispose();
//     middle_nameController.dispose();
//     last_nameController.dispose();
//     first_nameController.dispose();
//
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: SizedBox(
//           height: MediaQuery.of(context).size.height,
//           width: MediaQuery.of(context).size.width,
//           child: Padding(
//             padding: const EdgeInsets.all(24),
//             child: Column(
//               children: [
//                 const Spacer(),
//                 AppTextField(
//                   hint: "Электронная почта",
//                   controllerName: emailController,
//                   hintStyle: const TextStyle(color: Colors.deepPurple),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your email';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 AppTextField(
//                   hint: "Пароль",
//                   controllerName: passwordController,
//                   validator: (value) {
//                     if (value == null || value.length < 8) {
//                       return 'Пароль должен содержать не менее 8 символов';
//                     }
//                     return null;
//                   },
//                   hintStyle: const TextStyle(color: Colors.deepPurple),
//                 ),
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 AppTextField(
//                   hint: "Имя",
//                   controllerName: first_nameController,
//                   hintStyle: const TextStyle(color: Colors.deepPurple),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your first name';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 AppTextField(
//                   hint: "Фамилия",
//                   controllerName: last_nameController,
//                   hintStyle: const TextStyle(color: Colors.deepPurple),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your last name';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 AppTextField(
//                   hint: "Отчество",
//                   controllerName: middle_nameController,
//                   hintStyle: const TextStyle(color: Colors.deepPurple),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your middle name';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 AppTextField(
//                   hint: "Телефон",
//                   controllerName: phoneController,
//                   validator: (value) {
//                     if (value == null ||
//                         value.length != 10 ||
//                         !RegExp(r'\d').hasMatch(value)) {
//                       return 'Номер телефона должен содержать 10 цифр';
//                     }
//                     return null;
//                   },
//                   hintStyle: const TextStyle(color: Colors.deepPurple),
//                 ),
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 FutureBuilder<Map<String, String>>(
//                   future: cities,
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const CircularProgressIndicator();
//                     } else if (snapshot.hasError) {
//                       return Text('Error: ${snapshot.error}');
//                     } else {
//                       return DropdownButtonFormField<String>(
//                         value: selectedCity,
//                         hint: const Text('Выберите город'),
//                         items: snapshot.data!.entries.map((e) {
//                           return DropdownMenuItem<String>(
//                             value: e.key,
//                             child: Text(e.value),
//                           );
//                         }).toList(),
//                         onChanged: (value) {
//                           setState(() {
//                             selectedCity = value;
//                           });
//                         },
//                       );
//                     }
//                   },
//                 ),
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 const Spacer(),
//                 SizedBox(
//                   width: 400,
//                   height: 60,
//                   child: ElevatedButton(
//                       onPressed: () async {
//                         await register();
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.deepPurple,
//                         foregroundColor: Colors.grey[40],
//                       ),
//                       child: const Text("Зарегистрироваться")),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
