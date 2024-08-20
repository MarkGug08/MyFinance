import 'package:flutter/material.dart';
import '../../Controller/auth_controller.dart';
import '../Login/Widget/navigate_to_page.dart';
import '../Widget/auth_screen.dart';
import 'Widget/register_button.dart';
import 'Widget/textfield_registration.dart';
import 'Widget/welcome_text_registration.dart';

class RegisterScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthController _authController = AuthController();

  @override
  Widget build(BuildContext context) {
    return AuthScreen(
      formKey: _formKey,
      children: [
        const SizedBox(height: 10.0),
        previous_page_button(context),    //go back to previous page
        const SizedBox(height: 50.0),
        welcome_text(),
        const SizedBox(height: 40.0),
        nameTextField(_usernameController),   //username field
        const SizedBox(height: 10.0),
        emailTextField(_emailController),   //email field
        const SizedBox(height: 10.0),
        PasswordTextField(_passwordController),   //password field
        const SizedBox(height: 40.0),
        registerButton(_formKey, context, _authController, _usernameController, _emailController, _passwordController),
        const SizedBox(height: 10.0),
      ],
    );
  }
}
