import 'package:flutter/material.dart';
import 'package:myfinance/Authentication/Authentication_Controller/Widget/authentication_button.dart';
import 'package:myfinance/Authentication/Authentication_Controller/Widget/background.dart';
import 'package:myfinance/Authentication/Registration/register_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthScreen(),
    );
  }
}


class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double buttonWidth = constraints.maxWidth * 0.8;    //80% of the screen
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AuthenticationButton("Login", buttonWidth, context, true),
                      const SizedBox(height: 15),
                      AuthenticationButton("Register", buttonWidth, context, false),
                      const SizedBox(height: 15),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}