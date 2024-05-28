import 'package:flutter/material.dart';
import 'package:camshot/src/models/user.dart';
import 'package:camshot/src/models/user.dart';

class RegistrationStepTwo extends StatefulWidget {
  final UserModel user;

  RegistrationStepTwo({required this.user});

  @override
  _RegistrationStepTwoState createState() => _RegistrationStepTwoState();
}

class _RegistrationStepTwoState extends State<RegistrationStepTwo> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register - Step 2'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            // ??????? ??? avatar, passportNumber, passportPhoto, birthday, homeAddress...
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Complete Registration'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // ???????? ?????? ?? ??????
    }
  }
}
