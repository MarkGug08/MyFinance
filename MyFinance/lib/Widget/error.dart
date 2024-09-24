import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

void showError(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(message),
    backgroundColor: Colors.red,
    duration: Duration(seconds: 3),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

String handleError(dynamic error) {
  if (error is SocketException) {
    return 'Connection error: Please check your internet connection.';
  } else if (error is HttpException) {
    return 'Server error: Unable to retrieve data from the server.';
  } else if (error is FormatException) {
    return 'Data error: Failed to process the data from the server.';
  } else {
    return 'Unexpected error: ${error.toString()}';
  }
}

String handleBinanceError(int statusCode) {
  switch (statusCode) {
    case 400:
      return 'Bad Request: The server could not understand the request.';
    case 401:
      return 'Unauthorized: Please check your API credentials.';
    case 403:
      return 'Forbidden: Access to the requested resource is denied.';
    case 404:
      return 'Not Found: The requested resource could not be found.';
    case 429:
      return 'Too Many Requests: You have exceeded the API rate limit.';
    case 500:
      return 'Internal Server Error: An error occurred on the server.';
    default:
      return 'Error: An unexpected error occurred. Status code: $statusCode';
  }
}

String getFirebaseAuthErrorMessage(FirebaseAuthException e) {
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
