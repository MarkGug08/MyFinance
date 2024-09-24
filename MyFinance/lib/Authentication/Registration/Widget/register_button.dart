import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfinance/MainPage/main_page.dart';
import '../../../Controller/auth_controller.dart';
import '../../../HomePage/home_page.dart';
import '../../../Widget/error.dart';

Widget registerButton(
    GlobalKey<FormState> formKey,
    BuildContext context,
    AuthController authController,
    TextEditingController usernameController,
    TextEditingController emailController,
    TextEditingController passwordController,
    ) {
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
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          try {
            await authController.registerUser(
              username: usernameController.text,
              email: emailController.text,
              password: passwordController.text,
            );

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainPage()),
            );
          } catch (e) {
            if (e is FirebaseAuthException) {
              String errorMessage = getFirebaseAuthErrorMessage(e);
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
