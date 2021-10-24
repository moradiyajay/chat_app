import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseServiceProvider with ChangeNotifier {
  // GoogleSignInAccount? _user;
  bool _isLogin = true;
  String _userName = '';
  String _userEmail = '';
  String _userPassword = '';

  // GoogleSignInAccount get user => _user!;

  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userPassword => _userPassword;

  set isLogin(bool isLogin) {
    _isLogin = isLogin;
  }

  set userName(String userName) {
    _userName = userName;
  }

  set userEmail(String userEmail) {
    _userEmail = userEmail;
  }

  set userPassword(String userPassword) {
    _userPassword = userPassword;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<String?> signInwithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await _auth.signInWithCredential(credential);
      notifyListeners();
    } on FirebaseAuthException {
      notifyListeners();
      rethrow;
    }
  }

  Future<String?> signInWithEmail() async {
    try {
      if (_isLogin) {
        await _auth.signInWithEmailAndPassword(
            email: _userEmail, password: _userPassword);
        notifyListeners();
      } else {
        await _auth.createUserWithEmailAndPassword(
            email: _userEmail, password: _userPassword);
        notifyListeners();
      }
    } on FirebaseAuthException catch (error) {
      // print('error: ${error.code}');
      switch (error.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
        case "account-exists-with-different-credential":
        case "email-already-in-use":
          return "User already exists.";

        case "ERROR_WRONG_PASSWORD":
        case "wrong-password":
          return "Wrong email/password.";

        case "ERROR_USER_NOT_FOUND":
        case "user-not-found":
          return "No user found.";

        case "ERROR_USER_DISABLED":
        case "user-disabled":
          return "User disabled.";

        case "ERROR_TOO_MANY_REQUESTS":
        case "operation-not-allowed":
          return "Too many requests to log into this account.";

        case "ERROR_OPERATION_NOT_ALLOWED":
          return "Server error, please try again later.";

        case "ERROR_INVALID_EMAIL":
        case "invalid-email":
          return "Email address is invalid.";

        default:
          return "Login failed. Please try again.";
      }
    }
  }

  Future<void> signOut() async {
    if (await _googleSignIn.isSignedIn()) {
      await _googleSignIn.disconnect();
    }
    await _auth.signOut();
    notifyListeners();
  }
}
