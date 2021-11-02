// ignore_for_file: unnecessary_getters_setters

import 'dart:async';

import 'package:chat_app/provider/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'database_service.dart';

class FirebaseServiceProvider with ChangeNotifier {
  bool _isNewUser = true;
  String _userName = '';
  String _userEmail = '';
  String _userPassword = '';

  User? get user {
    return _auth.currentUser;
  }

  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userPassword => _userPassword;

  set isNewUser(bool isNewUser) {
    _isNewUser = isNewUser;
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
      _userName = user!.email!.replaceAll('@gmail.com', '');
      _userEmail = user!.email!;

      await DataBase().addUserToFirebase(user!.uid, {
        "displayName": user!.displayName,
        "email": user!.email,
        "profileURL": user!.photoURL,
        "userID": user!.uid,
        "username": user!.email!.replaceAll('@gmail.com', ''),
      });
      notifyListeners();
    } on FirebaseAuthException {
      notifyListeners();
      rethrow;
    }
  }

  Future<String?> signInWithEmail() async {
    try {
      if (_isNewUser) {
        await _auth.createUserWithEmailAndPassword(
          email: _userEmail,
          password: _userPassword,
        );
        notifyListeners();
      } else {
        await _auth.signInWithEmailAndPassword(
          email: _userEmail,
          password: _userPassword,
        );

        notifyListeners();
      }
      userName = user!.email!.replaceAll('@gmail.com', '');

      await DataBase().addUserToFirebase(user!.uid, {
        "displayName": user!.displayName,
        "email": user!.email,
        "profileURL": user!.photoURL,
        "userID": user!.uid,
        "username": user!.email!.replaceAll('@gmail.com', ''),
      });
    } on FirebaseAuthException catch (error) {
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
