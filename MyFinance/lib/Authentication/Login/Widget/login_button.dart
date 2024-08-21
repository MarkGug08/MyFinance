import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfinance/CryptoPage/CryptoHomePage/crypto_home_page.dart';

import '../../../Controller/auth_controller.dart';
import '../../../HomePage/home_page.dart';
import '../../Widget/error.dart';

/// Creates a login button that handles user authentication.
Widget login_button(
    GlobalKey<FormState> _formKey,
    BuildContext context,
    AuthController authController,
    TextEditingController emailController,
    TextEditingController passwordController,
    ) {
  return SizedBox(
    width: double.infinity, // Make the button as wide as its parent
    height: 50.0,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        backgroundColor: Colors.black,
      ),
      onPressed: () async {
        // Validate the form
        if (_formKey.currentState!.validate()) {
          try {
            // Attempt to sign in the user with provided email and password
            User? user = await authController.signInUser(
              email: emailController.text,
              password: passwordController.text,
            );

            // If the user is signed in successfully, navigate to the home page
            if (user != null) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MarketPage()),
                    (Route<dynamic> route) => false,
              );
            }
          } catch (e) {

            if (e is FirebaseAuthException) {

              String errorMessage = getErrorMessage(e);
              // Display the error message
              showError(context, errorMessage);
            } else {

              showError(context, 'An error occurred: ${e.toString()}');
            }

          }
        }
      },
      child: const Text(
        'Login',
        style: TextStyle(color: Colors.white),
      ),
    ),
  );
}
