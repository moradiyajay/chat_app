// ignore_for_file: prefer_const_constructors

import 'package:chat_app/provider/firebase_service.dart';
import 'package:chat_app/screens/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatRoomScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseServiceProvider firebaseServiceProvider =
        Provider.of<FirebaseServiceProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Chat App'),
        actions: [
          IconButton(
              onPressed: () async {
                await firebaseServiceProvider.signOut();
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (ctx, _, __) => StartScreen(),
                  ),
                );
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: Column(
        children: [
          Text('${firebaseServiceProvider.user}'),
        ],
      ),
    );
  }
}
