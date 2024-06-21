import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controllerName;
  const AppTextField(
      {super.key, required this.hint, required this.controllerName, required TextStyle hintStyle, required String? Function(String?) validator, });

  @override
  Widget build(BuildContext context) {
    FocusNode? focusNode;
    return SizedBox(
      height: MediaQuery.of(context).size.height*0.07,
      width: MediaQuery.of(context).size.width,
      child: TextField(
        controller: controllerName,
        focusNode: focusNode,
        decoration: InputDecoration(
            hintText: hint,
            labelText: hint,
            labelStyle: const TextStyle(color: Colors.white),
            border: const UnderlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.all(Radius.circular(30))),
            filled: true,
            fillColor: Colors.white.withOpacity(0.5)),
      ),
    );
  }
}