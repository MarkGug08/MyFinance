import 'package:flutter/material.dart';


Widget CustomAppBar(BuildContext context, String text) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    title: Text(
      text,
      style: const TextStyle(color: Colors.white),
    ),
    leading: Navigator.canPop(context)
        ? IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.white),
      onPressed: () {
        Navigator.pop(context);
      },
    )
        : null,
  );
}


