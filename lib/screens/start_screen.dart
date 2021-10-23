// ignore_for_file: prefer_const_constructors

import 'package:chat_app/screens/sign_in_screen.dart';
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
              // mainAxisSize: MainAxisSize.min,
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
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    margin: EdgeInsets.symmetric(vertical: 6),
                    width: double.infinity,
                    height: 45,
                    child: TextButton(
                      onPressed: () => Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder: (ctx, _, __) {
                            return SignUpScreen();
                          },
                        ),
                      ),
                      child: Text(
                        'Register',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    margin: EdgeInsets.symmetric(vertical: 6),
                    width: double.infinity,
                    height: 45,
                    child: TextButton(
                      onPressed: () => Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder: (ctx, _, __) {
                            return SignInScreen();
                          },
                        ),
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
