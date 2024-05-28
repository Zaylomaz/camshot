import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:camshot/src/services/authentication_service.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController cityIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(
                labelText: 'First Name',
              ),
            ),
            // ????????? ??? lastName, email, password, phone, cityId...
            ElevatedButton(
              onPressed: () {
                final String email = emailController.text;
                final String password = passwordController.text;
                // ??????? ????????? ??????...
                Provider.of<AuthenticationService>(context, listen: false)
                    .register(
                  firstNameController.text,
                  lastNameController.text,
                  email,
                  password,
                  phoneController.text,
                  cityIdController.text,
                );
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
