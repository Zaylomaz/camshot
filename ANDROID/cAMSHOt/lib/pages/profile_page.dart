import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePageScreen extends StatefulWidget {
  const ProfilePageScreen({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePageScreen> {
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passportNumberController = TextEditingController();
  final _homeAddressController = TextEditingController();
  final _birthdayController = TextEditingController();

  File? _avatar;
  File? _passportPhoto;

  Future<Map<String, dynamic>> fetchUserData() async {
    final response = await http.get(
      Uri.parse('https://yourapi.com/api/auth/user'),
      headers: {
        'Authorization': 'Bearer your_token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<void> _pickImage(bool isAvatar) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (isAvatar) {
          _avatar = File(pickedFile.path);
        } else {
          _passportPhoto = File(pickedFile.path);
        }
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_avatar == null || _passportPhoto == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select both avatar and passport photo')),
      );
      return;
    }

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://yourapi.com/api/auth/update_profile'),
    );

    request.headers['Authorization'] = 'Bearer your_token';

    request.fields['passport_number'] = _passportNumberController.text;
    request.fields['birthday'] = _birthdayController.text;
    request.fields['home_address'] = _homeAddressController.text;

    request.files.add(await http.MultipartFile.fromPath(
      'avatar',
      _avatar!.path,
      contentType: MediaType('image', 'jpeg'),
    ));

    request.files.add(await http.MultipartFile.fromPath(
      'passport_photo',
      _passportPhoto!.path,
      contentType: MediaType('image', 'jpeg'),
    ));

    final response = await request.send();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            var userData = snapshot.data!;
            _emailController.text = userData['email'];
            _firstNameController.text = userData['first_name'];
            _middleNameController.text = userData['middle_name'];
            _lastNameController.text = userData['last_name'];
            _phoneController.text = userData['phone'];
            _passportNumberController.text = userData['passport_number'];
            _homeAddressController.text = userData['home_address'];
            _birthdayController.text = userData['birthday'];

            return ListView(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
              children: <Widget>[
                _buildTextField('Email', _emailController),
                _buildTextField("Имя", _firstNameController),
                _buildTextField('Отчество', _middleNameController),
                _buildTextField('Фамилия', _lastNameController),
                _buildTextField('Телефон', _phoneController),
                _buildTextField('Номер паспорта', _passportNumberController),
                _buildTextField('Домашний адрес', _homeAddressController),
                _buildTextField('Дата рождения', _birthdayController),
                ElevatedButton(
                  onPressed: () => _pickImage(true),
                  child: const Text('Выбрать аватар'),
                ),
                ElevatedButton(
                  onPressed: () => _pickImage(false),
                  child: const Text('Выбрать фото паспорта'),
                ),
                ElevatedButton(
                  onPressed: _saveProfile,
                  child: const Text('Сохранить'),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return const Text('Ошибка загрузки данных');
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
    _emailController.dispose();
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _passportNumberController.dispose();
    _homeAddressController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }
}
