// ignore_for_file: prefer_const_constructors

import 'package:chat_app/components/text_field_container.dart';
import 'package:chat_app/provider/database_service.dart';
import 'package:chat_app/provider/firebase_service.dart';
import 'package:chat_app/screens/chat_room_screen.dart';
import 'package:chat_app/screens/start_screen.dart';
import 'package:chat_app/widgets/rectangle_search_field.dart';
import 'package:chat_app/widgets/search_list_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Stream userStream;
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();

  void onSearchBtnClick(String username) async {
    setState(() {
      isSearching = true;
    });
    userStream = await DataBase().getUserByUserName(username);
  }

  Widget searchUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: userStream as Stream<QuerySnapshot>,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data!.docs[index];
                  return SearchListTile(
                      profileUrl: ds["profileURL"],
                      name: ds["displayName"],
                      email: ds["email"],
                      username: ds["username"]);
                },
                itemCount: snapshot.data!.docs.length,
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              RectangleSearchField(
                onSearchBtnClick: onSearchBtnClick,
                searchController: searchController,
                onBackBtnClick: () {
                  setState(() {
                    isSearching = false;
                    searchController.clear();
                  });
                },
              ),
              isSearching ? searchUserList() : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
