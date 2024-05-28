import 'package:camshot/src/screens/registration_step_two.dart';
import 'package:flutter/material.dart';
import 'package:camshot/src/models/user.dart';

class RegistrationStepOne extends StatefulWidget {
  @override
  _RegistrationStepOneState createState() => _RegistrationStepOneState();
}

class _RegistrationStepOneState extends State<RegistrationStepOne> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Регистрация'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _firstNameController,
              decoration: InputDecoration(labelText: 'Имя'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите имя';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _lastNameController,
              decoration: InputDecoration(labelText: 'Фамилия'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите имя';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _firstNameController,
              decoration: InputDecoration(labelText: 'Отчество'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите имя';
                }
                return null;
              },
            ),

            TextFormField(
              controller: _firstNameController,
              decoration: InputDecoration(labelText: 'Телефон'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите имя';
                }
                return null;
              },
            ),

            // ????????? ??? lastName, middleName, email, password, phone, cityId...
            // ElevatedButton(
            // onPressed: _submitForm,
            // child: Text('Continue to Step 2'),
            // ),
          ],
        ),
      ),
    );
  }

  // void _submitForm() {
  //   if (_formKey.currentState!.validate()) {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => RegistrationStepTwo(
  //           user: User(
  //             firstName: _firstNameController.text,
  //             lastName: _lastNameController.text,
  //             middleName: _middleNameController.text,
  //             email: _emailController.text,
  //             password: _passwordController.text,
  //             phone: _phoneController.text,
  //             cityId: int.parse(_cityIdController.text),
  //           ),
  //         ),
  //       ),
  //     );
}
