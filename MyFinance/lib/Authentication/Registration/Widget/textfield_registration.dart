import 'package:flutter/material.dart';

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
    suffixIcon: suffixIcon,
  );
}



Widget nameTextField(TextEditingController controller) {
  return TextFormField(
    controller: controller,
    decoration: buildInputDecoration('Username'),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Enter your username';
      }
      if (value.length < 3) {
        return 'Username must be at least 3 characters long';
      }
      return null;
    },
  );
}

Widget emailTextField(TextEditingController controller) {
  return TextFormField(
    controller: controller,
    decoration: buildInputDecoration('Email'),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Enter your email';
      }
      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
        return 'Enter a valid email';
      }
      return null;
    },
  );
}

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;

  PasswordTextField(this.controller);

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: buildInputDecoration(
        'Password',
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
      obscureText: _obscureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter your password';
        }
        return null;
      },
    );
  }
}

