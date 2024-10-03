import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfinance/MainPage/main_page.dart';
import '../../../Controller/auth_controller.dart';
import '../../../Models/User.dart';
import '../../../Widget/error.dart';

Widget registerButton(
    GlobalKey<FormState> formKey,
    BuildContext context,
    AuthController authController,
    TextEditingController usernameController,
    TextEditingController emailController,
    TextEditingController passwordController,
    bool isLoading,
    Function(bool) setLoading,
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
      onPressed: isLoading ? null : () async {
        setLoading(true);
        if (formKey.currentState!.validate()) {
          try {
            User? user = await authController.registerUser(
              username: usernameController.text,
              email: emailController.text,
              password: passwordController.text,
            );

            if (user != null) {
              UserApp userApp = UserApp(
                Income: 0,
                Expenses: 0,
                UserEmail: user.email.toString(),
              );
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MainPage(user: userApp)),
              );
            }
          } catch (e) {
            if (e is FirebaseAuthException) {
              String errorMessage = getFirebaseAuthErrorMessage(e);
              showError(context, errorMessage);
            } else {
              showError(context, 'An error occurred: ${e.toString()}');
            }
          } finally {
            setLoading(false);
          }
        } else {
          setLoading(false);
        }
      },
      child: isLoading
          ? CircularProgressIndicator(color: Colors.white)
          : const Text(
        'Agree and register',
        style: TextStyle(color: Colors.white),
      ),
    ),
  );
}
