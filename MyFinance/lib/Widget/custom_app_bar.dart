import 'package:flutter/material.dart';

Widget CustomAppBar(BuildContext context, String text) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    title: Text(
      text,
      style: TextStyle(color: Colors.white),
    ),
    leading: Navigator.canPop(context) ? IconButton(
      icon: Icon(Icons.arrow_back, color: Colors.white),
      onPressed: () {
        Navigator.pop(context);
      },
    ) : null,
  );
}

