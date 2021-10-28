// ignore_for_file: prefer_const_constructors
import 'package:chat_app/provider/firebase_service.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:chat_app/screens/log_in_screen.dart';
import 'package:chat_app/screens/start_screen.dart';
import 'screens/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (_) => FirebaseServiceProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Color primaryColor = Color.fromRGBO(108, 99, 255, 1);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat APP',
      theme: ThemeData(
        primaryColor: primaryColor,
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: primaryColor,
              secondary: Colors.white,
              onSecondary: Colors.blueGrey.shade900,
            ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              primaryColor,
            ),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: primaryColor,
        ),
      ),
      routes: {
        '/': (ctx) => StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapShot) {
              if (snapShot.hasData) {
                return HomeScreen();
              } else {
                return StartScreen();
              }
            }),
        LogInScreen.routeName: (ctx) => LogInScreen(),
        RegisterScreen.routeName: (ctx) => RegisterScreen(),
      },
    );
  }
}
