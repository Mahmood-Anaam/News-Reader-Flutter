import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  static final FirebaseAuth authObj = FirebaseAuth.instance;

  static Future<String?> signIn(String email, String password) async {
    try {
      final UserCredential userCredential =
          await authObj.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user == null ? "Error sign In" : null;
    } catch (e, _) {
      return "Error Sign In";
    }
  }

  static Future<String?> signUp(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await authObj.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;

    } catch (e) {
      return "Error Sign Up";
    }
  }

  static Future<String?> signOut() async {
    try {
      await authObj.signOut();
    } catch (e) {
      return e.toString();
    }

    return null;
  }

  static Future<String?> recoverPassword(String email) async {
    try {
      await authObj.sendPasswordResetEmail(email: email.trim());
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}
