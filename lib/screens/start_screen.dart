// ignore_for_file: prefer_const_constructors

import 'package:chat_app/screens/log_in_screen.dart';
import 'package:chat_app/widgets/rectangle_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'register_screen.dart';

class StartScreen extends StatelessWidget {
  static String routename = '/start';
  const StartScreen({Key? key}) : super(key: key);

  void navigatTo(BuildContext context, bool newUser, Widget parent) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (ctx, _, __) {
          return AuthScreen(
            newUser: newUser,
          );
        },
        transitionDuration: Duration(milliseconds: 400),
        transitionsBuilder: (__, Animation<double> animation,
            Animation<double> animationReverse, Widget child) {
          // first exit current page and then enter new page
          return Stack(
            children: [
              SlideTransition(
                position: Tween<Offset>(
                  begin: Offset.zero,
                  end: const Offset(-1.0, 0.0),
                ).animate(animation),
                child: parent,
              ),
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              )
            ],
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
                    SvgPicture.asset(
                      'images/chat.svg',
                      height: size.height * 0.5,
                    ),
                    Text(
                      'Welcome To Chat App',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'It\'s free and secure \nwith End-To-End encryption',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
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
                      callback: () => navigatTo(context, true, this),
                    ),
                    RectangleButton(
                      text: "Log In",
                      backgroundColor: Colors.blueGrey.shade900,
                      callback: () {
                        navigatTo(context, false, this);
                      },
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
