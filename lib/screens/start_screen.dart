// ignore_for_file: prefer_const_constructors

import 'package:chat_app/screens/log_in_screen.dart';
import 'package:chat_app/widgets/rectangle_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'register_screen.dart';

class StartScreen extends StatelessWidget {
  static String routename = '/start';
  const StartScreen({Key? key}) : super(key: key);

  void navigatTo(BuildContext context, Widget widget) {
    Navigator.of(context).push(
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
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Stack(
            children: [
              Positioned(
                bottom: size.height * 0.125,
                top: 0,
                left: 0,
                right: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Chat App',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
                    ),
                    Image.asset(
                      'images/chat.png',
                      height: size.height * 0.5,
                    ),
                    Text(
                      'Welcome To Chat App',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    RectangleButton(
                      text: "Register",
                      backgroundColor: Theme.of(context).primaryColor,
                      callback: () => navigatTo(
                        context,
                        RegisterScreen(),
                      ),
                    ),
                    RectangleButton(
                      text: "Log In",
                      backgroundColor: Colors.blueGrey.shade900,
                      callback: () => navigatTo(
                        context,
                        LogInScreen(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
