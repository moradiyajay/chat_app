import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../helpers/database_service.dart';

class FirebaseServiceProvider {
  bool _isNewUser = true;
  String _username = '';
  String _userEmail = '';
  String _userPassword = '';

  User? get user {
    return _auth.currentUser;
  }

  set isNewUser(bool isNewUser) {
    _isNewUser = isNewUser;
  }

  set userName(String userName) {
    _username = userName;
  }

  set userEmail(String userEmail) {
    _userEmail = userEmail;
  }

  set userPassword(String userPassword) {
    _userPassword = userPassword;
  }

  String get getUserEmail => _userEmail;
  String get getUserPassword => _userPassword;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<String?> logInwithGoogle() async {
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
      _username = user!.email!.replaceAll('@gmail.com', '');
      _userEmail = user!.email!;

      await DataBase().addUserToFirebase(user!.uid, {
        "displayName": user!.displayName,
        "email": user!.email,
        "profileURL": user!.photoURL ??
            'https://ui-avatars.com/api/?name=$_username&background=random&rounded=true&size=128&format=png',
        "userID": user!.uid,
        "story": null,
        "username": _username,
      });
      if (user!.photoURL == null) {
        await user!.updatePhotoURL(
            "https://ui-avatars.com/api/?name=$_username&background=random&rounded=true&size=128&format=png");
      }

      // notifyListeners();
    } on FirebaseAuthException {
      // notifyListeners();
      rethrow;
    }
  }

  Future<String?> logInWithEmail() async {
    try {
      if (_isNewUser) {
        await _auth.createUserWithEmailAndPassword(
          email: _userEmail,
          password: _userPassword,
        );
        // notifyListeners();
      } else {
        await _auth.signInWithEmailAndPassword(
          email: _userEmail,
          password: _userPassword,
        );

        // notifyListeners();
      }
      _username = _userEmail.replaceAll('@gmail.com', '');

      await DataBase().addUserToFirebase(user!.uid, {
        "displayName": _username,
        "email": _userEmail,
        "profileURL":
            'https://ui-avatars.com/api/?name=$_username&background=random&rounded=true&size=128&format=png',
        "userID": user!.uid,
        "story": null,
        "username": _username,
      });
      await user!.updateDisplayName(_username);
      await user!.updatePhotoURL(
          "https://ui-avatars.com/api/?name=$_username&background=random&rounded=true&size=128&format=png");
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

  Future<void> logOut() async {
    if (await _googleSignIn.isSignedIn()) {
      await _googleSignIn.disconnect();
    }
    await _auth.signOut();
    // notifyListeners();
  }
}
