import 'package:flutter/material.dart';

import 'background.dart';

class AuthScreen extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final List<Widget> children;

  AuthScreen({required this.formKey, required this.children});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Background(),
          Center(
            child: FractionallySizedBox(
              heightFactor: 0.7,
              widthFactor: 0.9,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.white, Colors.grey[300]!],
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: children,
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
