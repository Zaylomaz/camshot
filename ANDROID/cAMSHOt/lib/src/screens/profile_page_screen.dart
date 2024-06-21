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
  File? avatarPhotoImage;
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

  Future<void> pickImageAV(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      avatarPhotoImage = File(pickedFile.path);
      final token = await storage.read(key: 'authToken');
      final uri =
          Uri.parse('https://dev.adsmap.kr.ua/api/v1/users/update-avatar');
      final request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $token';
      request.files
          .add(await http.MultipartFile.fromPath('avatar', pickedFile.path));
      final response = await request.send();

      if (response.statusCode == 200) {
        print('Image uploaded successfully');
      } else {
        print('Failed to upload image');
      }
    }
  }

  Future<void> pickImagePS(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      passportPhotoImage = File(pickedFile.path);
      final token = await storage.read(key: 'authToken');
      final uri = Uri.parse(
          'https://dev.adsmap.kr.ua/api/v1/users/update-passport-photo');
      final request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $token';
      request.files
          .add(await http.MultipartFile.fromPath('avatar', pickedFile.path));
      final response = await request.send();

      if (response.statusCode == 200) {
        print('Image uploaded successfully');
      } else {
        print('Failed to upload image');
      }
    }
  }

  Future<void> saveUser() async {
    final token = await storage.read(key: 'authToken');
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Token not found')),
      );
      return;
    }

    final uri =
        Uri.parse('http://dev.adsmap.kr.ua/api/v1/users/update').replace(
      queryParameters: {
        'first_name': firstNameController.text.toString(),
        'last_name': lastNameController.text.toString(),
        'middle_name': middleNameController.text.toString(),
        'phone': phoneController.text.toString(),
        'birthday': birthdayController.text.toString(),
        'password': passwordController.text.toString(),
        // 'email': emailController.text.toString(),
        'passport_number': passportNumberController.text.toString(),
        'home_address': homeAddressController.text.toString(),
        'home_cords': '1',
        'city_id': '1',
      },
    );
    final request = http.Request('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';
    // request.headers['Content-Type'] = 'application/json';
    // request.body = jsonEncode(params);

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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  ElevatedButton(
                    onPressed: () => pickImageAV(ImageSource.gallery),
                    child: const Text('Выбрать аватар'),
                  ),
                  ElevatedButton(
                    onPressed: () => pickImagePS(ImageSource.gallery),
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
      enabled: label != 'Email',
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
