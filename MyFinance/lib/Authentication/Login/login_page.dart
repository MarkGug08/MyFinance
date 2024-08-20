import 'package:flutter/material.dart';
import '../Widget/auth_screen.dart';
import 'Widget/login_button.dart';
import 'Widget/navigate_to_page.dart';
import 'Widget/textfield_login.dart';
import 'Widget/welcome_text.dart'; // Aggiungi l'import per RegisterScreen

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AuthScreen(
      formKey: _formKey,
      children: [
        const SizedBox(height: 10.0),
        previous_page_button(context),
        const SizedBox(height: 50.0),
        welcome_back_text(),
        const SizedBox(height: 50.0),
        emailTextField(),
        const SizedBox(height: 10.0),
        PasswordTextField(),
        const SizedBox(height: 80.0),
        login_button(_formKey, context),
        const SizedBox(height: 10.0),
        link_to_Register(context),
      ],
    );
  }
}
