// ignore_for_file: prefer_const_constructors

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
  late Stream userStream, chatRoomStream;
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();

  void onSearchBtnClick(String username) async {
    setState(() {
      isSearching = true;
    });
    userStream = await DataBase().getUserByUserName(username);
  }

  void listTileClick(String chatWithUsername, String profileUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatRoomScreen(
            chatWithUsername,
            FirebaseServiceProvider().user!.email!.replaceAll('@gmail.com', ''),
            profileUrl),
      ),
    );
  }

  initializeRoomStream() async {
    chatRoomStream = await DataBase().getChatRooms();
  }

  Widget getChatRoomsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: chatRoomStream as Stream<QuerySnapshot>,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                shrinkWrap: true,
                itemBuilder: (ctx, index) {
                  DocumentSnapshot ds = snapshot.data!.docs[index];
                  return Text(ds['username']);
                },
                itemCount: snapshot.data!.docs.length,
              )
            : CircularProgressIndicator();
      },
    );
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
                    username: ds["username"],
                    onClick: listTileClick,
                  );
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
  void initState() {
    super.initState();
    initializeRoomStream();
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
            mainAxisSize: MainAxisSize.min,
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
              isSearching
                  ? searchUserList()
                  : SizedBox(height: 200, child: getChatRoomsList()),
            ],
          ),
        ),
      ),
    );
  }
}
