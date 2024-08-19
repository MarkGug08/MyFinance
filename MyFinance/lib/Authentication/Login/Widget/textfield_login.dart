import 'package:flutter/material.dart';

Widget email_textfield() {
  return TextFormField(
    decoration: InputDecoration(
      labelText: 'Email',
      fillColor: Colors.grey[200], // Background color
      filled: true, // Enable background color
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
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Inserisci la tua email';
      }
      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
        return 'Inserisci un\'email valida';
      }
      return null;
    },
  );
}

Widget password_textfield() {
  return TextFormField(
    decoration: InputDecoration(
      labelText: 'Password',
      fillColor: Colors.grey[200], // Background color
      filled: true, // Enable background color
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
    ),
    obscureText: true,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Inserisci la tua password';
      }
      return null;
    },
  );
}
