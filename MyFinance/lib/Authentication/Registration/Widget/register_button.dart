import 'package:flutter/material.dart';
import 'package:myfinance/Authentication/Login/login_page.dart';
import 'package:myfinance/HomePage/home_page.dart';

Widget register_button(GlobalKey<FormState> _formKey, BuildContext context) {
  return SizedBox(
    width: double.infinity,
    height: 50.0,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),

        ),
        backgroundColor: Colors.black,

      ),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
      },
      child: const Text('Agree and register', style: TextStyle(color: Colors.white),),
    ),
  );
}