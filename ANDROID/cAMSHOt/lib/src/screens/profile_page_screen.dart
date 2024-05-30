import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:camshot/utils/http_service.dart';
import 'package:camshot/src/services/api_service.dart';

import '../models/user.dart';

class ProfilePageScreen extends StatefulWidget {
  final HttpService httpService =
      HttpService('https://dev.adsmap.kr.ua/api/auth/user');

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePageScreen> {
  static const storage = FlutterSecureStorage();
  File? passportPhotoImage;
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passportNumberController = TextEditingController();
  TextEditingController homeAddressController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final picker = ImagePicker();
  final String baseUrl = 'https://dev.adsmap.kr.ua/api/auth/user';
  late var userData = fetchUser();
  late var user = User();
  get token => storage.read(key: 'authToken');

  static get httpService =>
      HttpService('https://dev.adsmap.kr.ua/api/auth/user');

  Future<Map> fetchUser() async {
    final token = await storage.read(key: 'authToken');
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      var preData = jsonDecode(response.body);
      final Map result = {};
      result['email'] = preData['data']['email'];
      result['firstName'] = preData['data']['first_name'];
      result['middleName'] = preData['data']['middle_name'];
      result['lastName'] = preData['data']['last_name'];
      result['phone'] = preData['data']['phone'];
      result['passportNumber'] = preData['data']['passport_number'];
      result['homeAddress'] = preData['data']['home_address'];
      result['birthday'] = preData['data']['birthday'];
      return result;
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<void> pickImage(ImageSource source, bool isPassportNumber) async {
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        passportPhotoImage = File(pickedFile.path);
      }
    });
  }

  Future<void> saveUser() async {
    final token = await storage.read(key: 'authToken');
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Token not found')),
      );
      return;
    }

    final uri = Uri.parse('https://dev.adsmap.kr.ua/api/auth/register');
    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['first_name'] = firstNameController.text.toString();
    request.fields['last_name'] = lastNameController.text.toString();
    request.fields['middle_name'] = middleNameController.toString();
    request.fields['phone'] = phoneController.toString();
    // ..fields['birthday'] = birthdayController.toString();
    request.fields['password'] = passwordController.toString();
    ;

    if (passportPhotoImage != null) {
      request.files.add(await http.MultipartFile.fromPath(
          'passport_photo', passportPhotoImage!.path));
    }

    final response = await request.send();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Данные успешно сохранены')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при сохранении данных')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ApiService apiService = ApiService();
    final httpService = HttpService('https://dev.adsmap.kr.ua/api/auth/user');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
      ),
      body: FutureBuilder<Map>(
        future: fetchUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              var userData = snapshot.data!;
              emailController.text = userData['email'] ?? '';
              firstNameController.text = userData['firstName'] ?? '';
              middleNameController.text = userData['middleName'] ?? '';
              lastNameController.text = userData['lastName'] ?? '';
              phoneController.text = userData['phone'] ?? '';
              passportNumberController.text = userData['passportNumber'] ?? '';
              homeAddressController.text = userData['homeAddress'] ?? '';
              birthdayController.text = userData['birthday'] ?? '';

              return ListView(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
                children: <Widget>[
                  _buildTextField('Email', emailController),
                  _buildTextField('Пароль', passwordController),
                  _buildTextField("Имя", firstNameController),
                  _buildTextField('Отчество', middleNameController),
                  _buildTextField('Фамилия', lastNameController),
                  _buildTextField('Телефон', phoneController),
                  _buildTextField('Номер паспорта', passportNumberController),
                  _buildTextField('Домашний адрес', homeAddressController),
                  _buildTextField('Дата рождения', birthdayController),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  ElevatedButton(
                    onPressed: saveUser,
                    child: const Text('Сохранить'),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  ElevatedButton(
                    onPressed: () => pickImage(ImageSource.gallery, false),
                    child: const Text('Выбрать аватар'),
                  ),
                  ElevatedButton(
                    onPressed: () => pickImage(ImageSource.gallery, false),
                    child: const Text('Выбрать фото паспорта'),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return const Text('Ошибка загрузки данных');
            }
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    final specialBehaviors = {
      'Дата рождения': () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
          controller.text = formattedDate;
        }
      },
    };

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
      ),
      readOnly: specialBehaviors.containsKey(label),
      onTap: specialBehaviors[label],
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    passportNumberController.dispose();
    homeAddressController.dispose();
    birthdayController.dispose();
    super.dispose();
  }
}
