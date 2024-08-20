import 'package:flutter/material.dart';

/// Creates an InputDecoration with customizable styling.
InputDecoration buildInputDecoration(String label, {Widget? suffixIcon}) {
  return InputDecoration(
    labelText: label,
    fillColor: Colors.grey[200],
    filled: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: Colors.grey, width: 1.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: Colors.blue, width: 2.0),
    ),
    suffixIcon: suffixIcon, // Optional icon displayed at the end of the input field
  );
}

/// Creates a text field for email input with validation.
Widget emailTextField(TextEditingController controller) {
  return TextFormField(
    controller: controller, // Controller to manage the input field's text
    decoration: buildInputDecoration('Email'),

  );
}

/// Creates a password text field with visibility toggle functionality.
class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;

  PasswordTextField(this.controller);

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true; // Boolean to toggle password visibility

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller, // Controller to manage the input field's text
      decoration: buildInputDecoration(
        'Password',
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility, // Toggle icon based on visibility state
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText; // Toggle the password visibility
            });
          },
        ),
      ),
      obscureText: _obscureText, // Toggle text visibility
    );
  }
}
