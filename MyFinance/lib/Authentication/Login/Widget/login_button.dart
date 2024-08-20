import 'package:flutter/material.dart';

import '../../Registration/register_page.dart';

Widget login_button(_formKey, context){
  return SizedBox(
    width: double.infinity,
    height: 50.0,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),

        ),
        backgroundColor: Colors.black,
        textStyle: TextStyle( color: Colors.white) ,
      ),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegisterScreen()),
          );
        }
      },
      child: const Text('Login'),
    ),
  );
}