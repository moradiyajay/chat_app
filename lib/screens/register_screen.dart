// ignore_for_file: prefer_const_constructors

import 'package:chat_app/widgets/rectangle_button.dart';
import 'package:chat_app/widgets/rectangle_input_field.dart';
import 'package:chat_app/widgets/rectangle_password_field.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  static String routeName = '/sign-up';

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
                Text(
                  'Register',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: size.height * 0.03),
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
                SizedBox(height: 25),
                RectangleButton(
                  text: 'Register',
                  backgroundColor: Theme.of(context).primaryColor,
                  callback: () {},
                ),
                SizedBox(height: size.height * 0.03),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Alreay have an account? Log In',
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
    );
  }
}
