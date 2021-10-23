// ignore_for_file: prefer_const_constructors

import 'package:chat_app/screens/log_in_screen.dart';
import 'package:chat_app/widgets/rectangle_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'sign_up_screen.dart';

class startScreen extends StatelessWidget {
  static String routename = '/';
  const startScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/chat.png'),
                Text(
                  'Welcome To Chat App',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 15),
                Text(
                  'It\'s free and secure',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    RectangleButton(
                      text: "Register",
                      backgroundColor: Theme.of(context).primaryColor,
                      callback: () => Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder: (ctx, _, __) {
                            return SignUpScreen();
                          },
                        ),
                      ),
                    ),
                    RectangleButton(
                      text: "Log In",
                      backgroundColor: Colors.blueGrey.shade900,
                      callback: () => Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder: (ctx, _, __) {
                            return LogInScreen();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
