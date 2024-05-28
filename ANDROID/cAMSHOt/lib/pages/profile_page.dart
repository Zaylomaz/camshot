import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class ProfilePage extends StatefulWidget {
  final Future<Map<String, dynamic>> userDataFuture;

  const ProfilePage({super.key, required this.userDataFuture});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passportNumberController = TextEditingController();
  final _homeAddressController = TextEditingController();
  final _birthdayController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: widget.userDataFuture,
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
                  onPressed: _saveProfile,
                  child: const Text('Сохранить'),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return const Text('Ошибка загрузки данных');
          }
          return const CircularProgressIndicator();
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
      // 'Домашний адрес': () async {
      //   final result = await Navigator.push(context,
      //       MaterialPageRoute(builder: (context) => const MapScreen()));
      //   if (result != null) {
      //     controller.text = result as String;
      //   }
      // },
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

  void _saveProfile() {
    // Implement your save profile logic here
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
