import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Registers a new user with email and password.
  ///
  /// Throws an exception if registration fails.
  Future<User?> registerUser({
    required String username, // User's username
    required String email, // User's email
    required String password, // User's password
  }) async {
    try {
      // Create a new user with the given email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Retrieve the registered user
      User? user = userCredential.user;

      // Optionally: Update the user's profile with the username
      if (user != null) {
        await user.updateProfile(displayName: username);
        // Reload the user to get the updated profile information
        await user.reload();
        user = _auth.currentUser;
      }

      return user;
    } catch (e) {
      throw e;
    }
  }

  /// Signs in an existing user with email and password.
  ///
  /// Throws an exception if sign-in fails.
  Future<User?> signInUser({
    required String email, // User's email
    required String password, // User's password
  }) async {
    try {
      // Sign in the user with the given email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user;
    } catch (e) {
      throw e;
    }
  }
}
