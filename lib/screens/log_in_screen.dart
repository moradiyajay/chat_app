// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:ui';

import 'package:chat_app/provider/firebase_service.dart';
import 'package:chat_app/screens/chat_room_screen.dart';
import 'package:chat_app/screens/register_screen.dart';
import 'package:chat_app/widgets/rectangle_button.dart';
import 'package:chat_app/widgets/rectangle_input_field.dart';
import 'package:chat_app/widgets/rectangle_password_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class LogInScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  static String routeName = '/log-in';
  void navigatTo(BuildContext context, Widget widget) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (ctx, _, __) {
          return widget;
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
    FirebaseServiceProvider firebaseServiceProvider =
        Provider.of<FirebaseServiceProvider>(context);
    firebaseServiceProvider.isLogin = true;
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
                        // onTap: () => navigatTo(context, StartScreen()),
                        child: Icon(Icons.arrow_back_rounded),
                      ),
                      Container(
                        width: size.width,
                        height: 24,
                        alignment: Alignment.center,
                        child: Text(
                          'Login',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.03),
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
                    margin: EdgeInsets.symmetric(vertical: 12),
                    child: GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Forget Password?',
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  RectangleButton(
                    text: "Log In",
                    backgroundColor: Theme.of(context).primaryColor,
                    callback: () async {
                      bool isValid = _formKey.currentState!.validate();
                      if (isValid) {
                        _formKey.currentState!.save();
                        String? error =
                            await firebaseServiceProvider.signInWithEmail();
                        if (error != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(error),
                            ),
                          );
                        } else {
                          Navigator.pushAndRemoveUntil(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (ctx, _, __) => ChatRoomScreen(),
                            ),
                            (route) => false,
                          );
                        }
                      }
                    },
                  ),
                  SizedBox(height: size.height * 0.03),
                  GestureDetector(
                    onTap: () => navigatTo(context, RegisterScreen()),
                    child: Text(
                      'Don\'t have an account? Register',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
