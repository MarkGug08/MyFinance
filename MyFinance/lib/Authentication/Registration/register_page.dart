import 'package:flutter/material.dart';
import '../../Controller/auth_controller.dart';
import '../Login/Widget/navigate_to_page.dart';
import '../Widget/auth_screen.dart';
import 'Widget/register_button.dart';
import 'Widget/textfield_registration.dart';
import 'Widget/welcome_text_registration.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthController _authController = AuthController();

  bool _isLoading = false;

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
        emailTextField(_emailController),
        const SizedBox(height: 10.0),
        PasswordTextField(_passwordController),
        const SizedBox(height: 40.0),
        registerButton(
          _formKey,
          context,
          _authController,
          _emailController,
          _passwordController,
          _isLoading,
              (bool value) {
            setState(() {
              _isLoading = value;
            });
          },
        ),
        const SizedBox(height: 10.0),
        link_to_Login(context),
      ],
    );
  }
}
