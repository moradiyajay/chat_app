// ignore_for_file: prefer_const_constructors

import 'package:chat_app/firebase/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatRoomScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseServiceProvider firebaseServiceProvider =
        Provider.of<FirebaseServiceProvider>(context, listen: false);
    return Scaffold(
      body: Center(
        child: TextButton(
          child: Text('Log Out', style: TextStyle(color: Colors.white)),
          onPressed: () async {
            await firebaseServiceProvider.signOut();
          },
        ),
      ),
    );
  }
}
