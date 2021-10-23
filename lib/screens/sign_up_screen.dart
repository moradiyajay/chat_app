// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  static String routeName = '/sign-up';
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
                      SizedBox(height: 25),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Comfirm Password',
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
                      loginButton(context, 'Register'),
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
