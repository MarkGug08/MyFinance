import 'package:flutter/material.dart';

Widget AuthenticationButton(String typeofButton, double buttonWidth) {    //Button to manage redirection between login and registration
  return ElevatedButton(
    onPressed: () {

    },
    style: ElevatedButton.styleFrom(
      minimumSize: Size(buttonWidth, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      textStyle: const TextStyle(
        fontSize: 18,
      ),
    ),
    child: Text(
      typeofButton,
      style: const TextStyle(
        color: Colors.black,
      ),
    ),
  );
}
