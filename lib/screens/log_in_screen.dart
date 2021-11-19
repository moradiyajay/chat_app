import 'dart:ui';

import 'package:chat_app/components/or_divider.dart';
import 'package:chat_app/components/social_icon.dart';
import 'package:chat_app/provider/firebase_service.dart';
import 'package:chat_app/screens/chats_screen.dart';
import 'package:chat_app/screens/auth_screen.dart';
import 'package:chat_app/widgets/rectangle_button.dart';
import 'package:chat_app/widgets/rectangle_input_field.dart';
import 'package:chat_app/widgets/rectangle_password_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LogInScreen extends StatefulWidget {
  static String routeName = '/log-in';

  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLogingIn = false;

  void navigatTo(BuildContext context, Widget widget) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (ctx, _, __) {
          return widget;
        },
        transitionsBuilder:
            (__, Animation<double> animation, ____, Widget child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  togleIsLoginIn() {
    setState(() {
      isLogingIn = !isLogingIn;
    });
  }

  emailLogIn(FirebaseServiceProvider firebaseServiceProvider) async {
    bool isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      togleIsLoginIn();
      firebaseServiceProvider.logInWithEmail().then((error) {
        togleIsLoginIn();
        if (error != null) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error),
            ),
          );
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              PageRouteBuilder(
                pageBuilder: (ctx, _, __) => const ChatsScreen(),
              ),
              (route) => false);
        }
      });
    }
  }

  googleLogIn(FirebaseServiceProvider firebaseServiceProvider) {
    togleIsLoginIn();
    firebaseServiceProvider.logInwithGoogle().then(
      (error) {
        togleIsLoginIn();
        if (error != null) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error),
            ),
          );
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            PageRouteBuilder(
              pageBuilder: (ctx, _, __) => const ChatsScreen(),
            ),
            (route) => false,
          );
        }
      },
    ).catchError((error) {
      togleIsLoginIn();
      if (error != null) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    FirebaseServiceProvider firebaseServiceProvider = FirebaseServiceProvider();
    firebaseServiceProvider.isNewUser = false;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24),
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back_rounded),
                      ),
                      Container(
                        width: size.width,
                        height: 24,
                        alignment: Alignment.center,
                        child: const Text(
                          'Login',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.02),
                  SvgPicture.asset(
                    'images/login.svg',
                    height: size.height * 0.25,
                  ),
                  RectangleInputField(
                    icon: Icons.person,
                    hintText: "Email",
                    primaryColor: Colors.blueGrey.shade900,
                    secondaryColor: Theme.of(context).colorScheme.secondary,
                    onSaved: (value) =>
                        firebaseServiceProvider.userEmail = value,
                  ),
                  RectanglePasswordField(
                    icon: Icons.lock,
                    hintText: "Password",
                    primaryColor: Colors.blueGrey.shade900,
                    secondaryColor: Theme.of(context).colorScheme.secondary,
                    onSaved: (value) =>
                        firebaseServiceProvider.userPassword = value,
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    child: GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'Forget Password?',
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  isLogingIn
                      ? const CircularProgressIndicator()
                      : RectangleButton(
                          text: "Log In",
                          backgroundColor: Theme.of(context).primaryColor,
                          callback: () => emailLogIn(firebaseServiceProvider),
                        ),
                  SizedBox(height: size.height * 0.03),
                  GestureDetector(
                    onTap: () => navigatTo(context, const AuthScreen()),
                    child: Text(
                      'Don\'t have an account? Register',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.01),
                  const OrDivider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocialIcon(
                        assetName: 'images/google.svg',
                        callback: () => googleLogIn(firebaseServiceProvider),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
