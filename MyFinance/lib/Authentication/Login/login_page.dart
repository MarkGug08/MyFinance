import 'package:flutter/material.dart';
import 'package:myfinance/Authentication/Authentication_Page/Widget/background.dart';
import 'package:myfinance/Authentication/Login/Widget/login_button.dart';
import 'package:myfinance/Authentication/Login/Widget/navigate_to_page.dart';
import 'package:myfinance/Authentication/Login/Widget/textfield_login.dart';
import 'package:myfinance/Authentication/Login/Widget/welcome_text.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,    //don't change the layout when the user use the textfield
      body: Stack(
        children: [
          Background(),
          Center(
            child: FractionallySizedBox(
              heightFactor: 0.7, // height
              widthFactor: 0.9,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white,
                      Colors.grey[300]!,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 10.0),
                      previous_page_button(context), // button for previous page
                      const SizedBox(height: 50.0),
                      welcome_text(),
                      const SizedBox(height: 50.0),
                      emailTextField(), // email field
                      const SizedBox(height: 10.0),
                      PasswordTextField(), // password field
                      const SizedBox(height: 80.0),
                      login_button(_formKey, context), //login button
                      const SizedBox(height: 10.0),
                      link_to_Register(context) //link to registration
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
