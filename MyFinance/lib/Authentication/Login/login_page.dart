import 'package:flutter/material.dart';
import 'package:myfinance/Authentication/Login/Widget/welcome_back_text.dart';
import '../../Controller/auth_controller.dart';
import '../Widget/auth_screen.dart';
import 'Widget/navigate_to_page.dart';
import 'Widget/textfield_login.dart';
import 'Widget/login_button.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthController _authController = AuthController();

  @override
  Widget build(BuildContext context) {
    return AuthScreen(
      formKey: _formKey,
      children: [
        const SizedBox(height: 10.0),
        previous_page_button(context),
        const SizedBox(height: 50.0),
        welcome_back_text(),
        const SizedBox(height: 40.0),
        emailTextField(_emailController),
        const SizedBox(height: 10.0),
        PasswordTextField(_passwordController),
        const SizedBox(height: 40.0),
        login_button(_formKey, context, _authController, _emailController, _passwordController),
        const SizedBox(height: 10.0),
        link_to_Register(context)
      ],
    );
  }
}
