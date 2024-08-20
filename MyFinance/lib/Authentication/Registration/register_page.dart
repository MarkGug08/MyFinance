import 'package:flutter/material.dart';

import '../Login/Widget/navigate_to_page.dart';
import '../Widget/auth_screen.dart';
import 'Widget/register_button.dart';
import 'Widget/textfield_registration.dart';
import 'Widget/welcome_text_registration.dart';


class RegisterScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AuthScreen(
      formKey: _formKey,
      children: [
        const SizedBox(height: 10.0),
        previous_page_button(context),
        const SizedBox(height: 50.0),
        welcome_text(),
        const SizedBox(height: 40.0),
        nameTextField(),
        const SizedBox(height: 10.0),
        emailTextField(),
        const SizedBox(height: 10.0),
        PasswordTextField(),
        const SizedBox(height: 40.0),
        register_button(_formKey, context),
        const SizedBox(height: 10.0),

      ],
    );
  }
}
