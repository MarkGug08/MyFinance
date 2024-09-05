import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfinance/MainPage/main_page.dart';
import '../../../Controller/auth_controller.dart';
import '../../../HomePage/home_page.dart';
import '../../../Widget/error.dart';

/// Creates a button for user registration that handles form submission and navigation.
Widget registerButton(
    GlobalKey<FormState> formKey,
    BuildContext context,
    AuthController authController,
    TextEditingController usernameController,
    TextEditingController emailController,
    TextEditingController passwordController,
    ) {
  return SizedBox(
    width: double.infinity, // Make the button span the full width of its container
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
        if (formKey.currentState!.validate()) {
          try {
            // Attempt to register the user with the provided details
            await authController.registerUser(
              username: usernameController.text,
              email: emailController.text,
              password: passwordController.text,
            );

            // If registration is successful, navigate to the HomePage
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainPage()),
            );
          } catch (e) {

            if (e is FirebaseAuthException) {

              String errorMessage = getFirebaseAuthErrorMessage(e);
              // Display the error message
              showError(context, errorMessage);
            } else {
              showError(context, 'An error occurred: ${e.toString()}');
            }
          }
        }
      },
      child: const Text(
        'Agree and register',
        style: TextStyle(color: Colors.white),
      ),
    ),
  );
}
