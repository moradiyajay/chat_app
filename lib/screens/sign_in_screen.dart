// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatelessWidget {
  static String routeName = '/sign-in';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              FittedBox(
                child: Image.asset(
                  'images/login_0.png',
                  width: 200,
                ),
              ),
              Card(
                shadowColor: Colors.black,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 25),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'Forget Password?',
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                          ),
                        ),
                      ),
                      loginButton(context, 'LogIn'),
                      Text('Or'),
                      loginButton(context, 'LogIn with Google'),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget loginButton(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      width: double.infinity,
      height: 50,
      child: TextButton(
        onPressed: () {},
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
