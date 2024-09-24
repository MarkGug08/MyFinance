import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfinance/CryptoPage/CryptoHomePage/crypto_home_page.dart';
import 'package:myfinance/MainPage/main_page.dart';

import '../../../Controller/auth_controller.dart';
import '../../../HomePage/home_page.dart';
import '../../../Widget/error.dart';

Widget login_button(
    GlobalKey<FormState> _formKey,
    BuildContext context,
    AuthController authController,
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
        if (_formKey.currentState!.validate()) {
          try {
            User? user = await authController.signInUser(
              email: emailController.text,
              password: passwordController.text,
            );

            if (user != null) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MainPage()),
                    (Route<dynamic> route) => false,
              );
            }
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
        'Login',
        style: TextStyle(color: Colors.white),
      ),
    ),
  );
}
