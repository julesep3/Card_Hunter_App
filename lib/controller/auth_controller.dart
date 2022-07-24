import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  // function to sign in using email and password
  static Future<User?> signIn(
      {required String email, required String password}) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }

  // function to sign out of app
  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  // function to create an account with email and password
  static Future<void> createAccount({
    required String email,
    required String password,
  }) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }

  // function to update a user's display name
  static Future<void> updateDisplayName({
    required String displayName,
    required User user,
  }) {
    return user.updateDisplayName(displayName);
  }

  // function to update a user's email
  static Future<void> updateEmail({
    required String email,
    required User user,
  }) async {
    await user.updateEmail(email);
  }

  // function to update a user's password
  static Future<void> updatePassword({
    required String password,
    required User user,
  }) async {
    user.updatePassword(password);
  }

  // function to update a user's profile picture
  static Future<void> updatePhotoURL({
    required String photoURL,
    required User user,
  }) {
    return user.updatePhotoURL(photoURL);
  }

  // function to delete a user
  static Future<void> delete({
    required User user,
  }) async {
    return user.delete();
  }
}
