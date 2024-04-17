import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final Future<Map<String, dynamic>> userDataFuture;

  ProfilePage({required this.userDataFuture});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _emailController;
  late TextEditingController _firstNameController;
  late TextEditingController _middleNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _passportNumberController;
  late TextEditingController _homeAddressController;

  @override
  void initState() {
    super.initState();
    // Здесь мы инициализируем контроллеры пустыми значениями, которые потом будем обновлять
    _emailController = TextEditingController();
    _firstNameController = TextEditingController();
    _middleNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneController = TextEditingController();
    _passportNumberController = TextEditingController();
    _homeAddressController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Профиль'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: widget.userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            var userData = snapshot.data!;
            // Обновляем значения контроллеров данными пользователя
            _emailController.text = userData['email'];
            _firstNameController.text = userData['first_name'];
            _middleNameController.text = userData['middle_name'];
            _lastNameController.text = userData['last_name'];
            _phoneController.text = userData['phone'];
            _passportNumberController.text = userData['passport_number'];
            _homeAddressController.text = userData['home_address'];

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
                ElevatedButton(
                  onPressed: _saveProfile,
                  child: Text('Сохранить'),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text('Ошибка загрузки данных');
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
      ),
    );
  }

  void _saveProfile() {
    // Вставить код для сохранения профиля
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
    super.dispose();
  }
}
