// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:chat_app/components/or_divider.dart';
import 'package:chat_app/components/social_icon.dart';
import 'package:chat_app/screens/log_in_screen.dart';
import 'package:chat_app/widgets/rectangle_button.dart';
import 'package:chat_app/widgets/rectangle_input_field.dart';
import 'package:chat_app/widgets/rectangle_password_field.dart';
import 'package:chat_app/firebase/firebase_service.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  static String routeName = '/sign-up';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  void navigatToLogin(BuildContext context) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (ctx, _, __) {
          return LogInScreen();
        },
        transitionsBuilder:
            (__, Animation<double> animation, ____, Widget child) {
          const begin = Offset(1.0, 0);
          const end = Offset.zero;
          final tween = Tween(begin: begin, end: end);
          final offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24),
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.arrow_back_rounded),
                    ),
                    Container(
                      width: size.width,
                      height: 24,
                      alignment: Alignment.center,
                      child: Text(
                        'Register',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
                Image.asset(
                  'images/login_0.png',
                  height: size.height * 0.25,
                ),
                RectangleInputField(
                  hintText: 'Email',
                  primaryColor: Theme.of(context).colorScheme.onSecondary,
                  secondaryColor: Colors.white,
                  icon: Icons.person,
                ),
                RectanglePasswordField(
                  hintText: 'Password',
                  primaryColor: Theme.of(context).colorScheme.onSecondary,
                  secondaryColor: Colors.white,
                  icon: Icons.lock,
                ),
                RectanglePasswordField(
                  hintText: 'Confirm Password',
                  primaryColor: Theme.of(context).colorScheme.onSecondary,
                  secondaryColor: Colors.white,
                  icon: Icons.lock,
                ),
                SizedBox(height: size.height * 0.025),
                RectangleButton(
                  text: 'Register',
                  backgroundColor: Theme.of(context).primaryColor,
                  callback: () {},
                ),
                SizedBox(height: size.height * 0.025),
                GestureDetector(
                  onTap: () => navigatToLogin(context),
                  child: Text(
                    'Alreay have an account? Log In',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                OrDivider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocialIcon(
                      assetName: 'images/facebook.svg',
                      callback: () {},
                    ),
                    SocialIcon(
                      assetName: 'images/google.svg',
                      callback: () async {
                        await FirebaseService().signInwithGoogle();
                      },
                    ),
                    SocialIcon(
                      assetName: 'images/twitter.svg',
                      callback: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
