import 'package:flutter/material.dart';
import 'package:myfinance/Authentication/Login/login_page.dart';
import 'package:myfinance/Authentication/Registration/register_page.dart';

Widget AuthenticationButton(String typeofButton, double buttonWidth, BuildContext context, bool isLogin) {
  return ElevatedButton(
    onPressed: () {
      if (isLogin) {
        GoToLoginPage(context);
      } else {
        GoToRegistrationPage(context);
      }
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

void GoToLoginPage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => LoginScreen()),
  );
}

void GoToRegistrationPage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => RegisterScreen()),
  );
}
