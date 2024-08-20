import 'package:flutter/material.dart';
import 'package:myfinance/Authentication/Registration/register_page.dart';

/// Creates a button to navigate back to the previous page.
Widget previous_page_button(BuildContext context) {
  return Align(
    alignment: Alignment.topLeft,
    child: Container(
      width: 40.0,
      height: 40.0,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          Navigator.pop(context); // Navigate back to the previous page
        },
      ),
    ),
  );
}

/// Creates a link to the registration page.
Widget link_to_Register(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text("Don't have an account? "),
      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegisterScreen()), // Navigate to the registration screen
          );
        },
        child: const Text(
          'Register now',
          style: TextStyle(
            color: Colors.blue,
          ),
        ),
      ),
    ],
  );
}
