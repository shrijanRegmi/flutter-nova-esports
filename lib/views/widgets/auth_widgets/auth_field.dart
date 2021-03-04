import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType type;
  final bool isPassword;

  AuthField({
    this.label,
    this.controller,
    this.type,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      cursorColor: Color(0xff5C49E0),
      textInputAction: TextInputAction.done,
      style: TextStyle(
        color: Color(0xff3D4A5A),
      ),
      decoration: InputDecoration(
        hintText: label,
        hintStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13.0,
          color: Colors.grey,
        ),
        alignLabelWithHint: true,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xff3D4A5A),
          ),
        ),
      ),
    );
  }
}
