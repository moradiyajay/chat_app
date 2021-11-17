import 'package:chat_app/provider/firebase_service.dart';
import 'package:chat_app/widgets/rectangle_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _isSettingsHome = true;
  String _currentScreen = 'settings';
  final FirebaseServiceProvider _firebaseServiceProvider =
      FirebaseServiceProvider();
  late User _user;

  @override
  void initState() {
    super.initState();
    _user = _firebaseServiceProvider.user!;
  }

  onClick() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              height: 35,
              child: _isSettingsHome
                  ? null
                  : IconButton(
                      onPressed: () {
                        setState(() {
                          _isSettingsHome = true;
                          _currentScreen = "Settings";
                        });
                      },
                      icon: const Icon(Icons.arrow_back))),
          Center(
            child: CircleAvatar(
              backgroundImage: NetworkImage(_user.photoURL!),
              radius: 28,
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              _user.displayName!,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
              child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            margin: const EdgeInsets.only(top: 24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(40),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _currentScreen,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                if (_isSettingsHome) ...[
                  SettingsOption(
                      onTap: () {
                        setState(() {
                          _currentScreen = "Account Settings";
                          _isSettingsHome = false;
                        });
                      },
                      text: 'Account Settings'),
                  SettingsOption(
                      onTap: () {
                        setState(() {
                          _currentScreen = "Notifications";
                          _isSettingsHome = false;
                        });
                      },
                      text: 'Notifications'),
                  SettingsOption(
                      onTap: () {
                        setState(() {
                          _currentScreen = "Report a Problem";
                          _isSettingsHome = false;
                        });
                      },
                      text: 'Report a Problem'),
                  SettingsOption(
                      onTap: () {
                        setState(() {
                          _currentScreen = "Help & Support";
                          _isSettingsHome = false;
                        });
                      },
                      text: 'Help & Support'),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: RectangleButton(
                      text: 'Log Out',
                      callback: () {
                        FirebaseServiceProvider().logOut();
                      },
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ]
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class SettingsOption extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  const SettingsOption({
    required this.onTap,
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Icon(
              CupertinoIcons.forward,
              color: Colors.black54,
            )
          ],
        ),
      ),
    );
  }
}
