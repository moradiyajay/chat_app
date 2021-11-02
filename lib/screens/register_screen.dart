import 'package:chat_app/components/or_divider.dart';
import 'package:chat_app/components/social_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/widgets/rectangle_button.dart';
import 'package:chat_app/widgets/rectangle_input_field.dart';
import 'package:chat_app/widgets/rectangle_password_field.dart';
import 'package:chat_app/provider/firebase_service.dart';

class AuthScreen extends StatefulWidget {
  static String routeName = '/auth-screen';
  final bool newUser;

  const AuthScreen({Key? key, this.newUser = true}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  late bool isNewUser;
  final TextEditingController _pass = TextEditingController();
  late FirebaseServiceProvider firebaseServiceProvider;

  void toggleAuth(BuildContext context) {
    setState(() {
      isNewUser = !isNewUser;
      firebaseServiceProvider.isNewUser = isNewUser;
    });
  }

  togleLoading() {
    setState(() => isLoading = !isLoading);
  }

  emailAuth(FirebaseServiceProvider firebaseServiceProvider) async {
    bool isValide = _formKey.currentState!.validate();
    if (isValide) {
      _formKey.currentState!.save();
      togleLoading();
      firebaseServiceProvider.signInWithEmail().then(
        (error) {
          togleLoading();
          error != null ? errorHandler(error) : navigatToHomeScreen();
        },
      ).catchError((error) {
        togleLoading();
        if (error != null) errorHandler(error);
      });
    }
  }

  googleLogIn(FirebaseServiceProvider firebaseServiceProvider) {
    togleLoading();
    firebaseServiceProvider.signInwithGoogle().then(
      (error) {
        togleLoading();
        error != null ? errorHandler(error) : navigatToHomeScreen();
      },
    ).catchError((error) {
      togleLoading();
      if (error != null) errorHandler(error);
    });
  }

  errorHandler(String error) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
      ),
    );
  }

  navigatToHomeScreen() {
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (ctx, _, __) => const HomeScreen(),
      ),
      (route) => false,
    );
  }

  @override
  void initState() {
    isNewUser = widget.newUser;
    firebaseServiceProvider =
        Provider.of<FirebaseServiceProvider>(context, listen: false);
    firebaseServiceProvider.isNewUser = isNewUser;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _pass.dispose();
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
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back_rounded),
                      ),
                      Container(
                        width: size.width,
                        height: 24,
                        alignment: Alignment.center,
                        child: Text(
                          isNewUser ? 'Register' : 'Login',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.02),
                  SvgPicture.asset(
                    'images/login.svg',
                    height: size.height * 0.25,
                  ),
                  RectangleInputField(
                    hintText: 'Email',
                    primaryColor: Theme.of(context).colorScheme.onSecondary,
                    secondaryColor: Colors.white,
                    icon: Icons.person,
                    onSaved: (value) =>
                        firebaseServiceProvider.userEmail = value,
                  ),
                  RectanglePasswordField(
                    hintText: 'Password',
                    controller: _pass,
                    primaryColor: Theme.of(context).colorScheme.onSecondary,
                    secondaryColor: Colors.white,
                    icon: Icons.lock,
                    textInputAction:
                        isNewUser ? TextInputAction.next : TextInputAction.done,
                    onSaved: (value) {
                      if (!isNewUser) {
                        firebaseServiceProvider.userPassword = value;
                      }
                    },
                  ),
                  isNewUser
                      ? RectanglePasswordField(
                          hintText: 'Confirm Password',
                          primaryColor:
                              Theme.of(context).colorScheme.onSecondary,
                          secondaryColor: Colors.white,
                          icon: Icons.lock,
                          confirmController: _pass,
                          onSaved: (value) =>
                              firebaseServiceProvider.userPassword = value,
                        )
                      : Container(
                          alignment: Alignment.centerRight,
                          margin: const EdgeInsets.symmetric(vertical: 12),
                          child: GestureDetector(
                            onTap: () {},
                            child: const Text(
                              'Forget Password?',
                              style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                  SizedBox(height: size.height * (isNewUser ? 0.025 : 0)),
                  isLoading
                      ? const CircularProgressIndicator()
                      : RectangleButton(
                          text: isNewUser ? 'Register' : 'Log In',
                          backgroundColor: Theme.of(context).primaryColor,
                          callback: () => emailAuth(firebaseServiceProvider),
                        ),
                  SizedBox(height: size.height * 0.025),
                  GestureDetector(
                    onTap: () => toggleAuth(context),
                    child: Text(
                      isNewUser
                          ? 'Alreay have an account? Log In'
                          : 'Don\'t have an account? Register',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (!isNewUser) ...[
                    SizedBox(height: size.height * 0.01),
                    OrDivider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Facebook, twitter login
                        SocialIcon(
                          assetName: 'images/google.svg',
                          callback: () => googleLogIn(firebaseServiceProvider),
                        ),
                      ],
                    ),
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
