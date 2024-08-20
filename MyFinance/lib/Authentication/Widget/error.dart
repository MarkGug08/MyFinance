import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Returns a user-friendly error message based on the FirebaseAuthException code.
String getErrorMessage(FirebaseAuthException e) {
  switch (e.code) {
    case 'user-not-found':
      return 'No user found for that email.';
    case 'wrong-password':
      return 'Wrong password provided for that user.';
    case 'invalid-email':
      return 'The email address is not valid.';
    case 'email-already-in-use':
      return 'The account already exists for that email.';
    case 'weak-password':
      return 'The password provided is too weak.';
    case 'invalid-credential':
      return 'The credentials are incorrect or expired.';
    default:
      return 'An unknown error occurred. Please try again later.';
  }


}

/// Displays an error message
void showError(BuildContext context, String errorMessage) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(errorMessage),
      backgroundColor: Colors.red,
    ),
  );
}
