// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../provider/database_service.dart';
import '../provider/firebase_service.dart';
import 'chat_room_screen.dart';
import 'start_screen.dart';
import '../widgets/chat_room_list_tile.dart';
import '../widgets/search_list_tile.dart';
import '../widgets/story_tile.dart';

class ChatsScreen extends StatefulWidget {
  static String routeName = '/chats';
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  late Stream userStream;
  late Stream chatRoomStream;
  String myUsername = '';
  bool isLogingOut = false;
  bool isSearchOn = false;
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();

  void onSearchBtnClick(String username) async {
    if (username == myUsername) return;
    setState(() {
      isSearching = true;
    });
    userStream = await DataBase().getUserByUserName(username);
  }

  void listTileClick(String chatWithUsername, String profileUrl) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, _, __) => ChatRoomScreen(
          chatWithUsername,
          myUsername,
          profileUrl,
        ),
      ),
    );
  }

  initializeRoomStream() async {
    chatRoomStream = await DataBase().getChatRooms();
    setState(() {});
  }

  Widget getChatRoomsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: chatRoomStream as Stream<QuerySnapshot>,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return snapshot.hasData
            ? snapshot.data!.docs.isEmpty
                ? Center(child: Text('Start Chating'))
                : ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (ctx, index) {
                      DocumentSnapshot ds = snapshot.data!.docs[index];
                      return ChatRoomListTile(
                        lastMessage: ds['lastMessage'],
                        chatRoomId: ds.id,
                        dateTime: (ds['lastTs'] as Timestamp).toDate(),
                        myUsername: myUsername,
                        onClick: listTileClick,
                      );
                    },
                    itemCount: snapshot.data!.docs.length,
                  )
            : const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget searchUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: userStream as Stream<QuerySnapshot>,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return snapshot.hasData
            ? snapshot.data!.docs.isEmpty
                ? Center(child: Text('No User Found'))
                : ListView.builder(
                    shrinkWrap: true,
                    // reverse: true,
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
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  logOut(FirebaseServiceProvider firebaseServiceProvider) async {
    setState(() {
      isLogingOut = !isLogingOut;
    });
    await firebaseServiceProvider.signOut();
    setState(() {
      isLogingOut = !isLogingOut;
    });
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (ctx, _, __) => StartScreen(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    myUsername =
        FirebaseServiceProvider().user!.email!.replaceAll('@gmail.com', '');
    initializeRoomStream();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // FirebaseServiceProvider firebaseServiceProvider =
    //     Provider.of<FirebaseServiceProvider>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 330,
              collapsedHeight: 70,
              toolbarHeight: 60,
              pinned: true,
              backgroundColor: Color.fromRGBO(244, 241, 253, 1),
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                title: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  padding:
                      EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 10),
                  margin: EdgeInsets.only(top: 0),
                  child: Row(
                    textBaseline: TextBaseline.alphabetic,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    children: [
                      Text(
                        'Chats',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          'Manage',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                titlePadding: EdgeInsets.zero,
                background: Column(
                  children: [
                    SizedBox(height: 10),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          'https://data.whicdn.com/images/322027365/original.jpg?t=1541703413', //!
                        ),
                      ),
                      title: Text(
                        'Good Morning', // !
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          'Alexie Blender', // !
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RoundIconButton(
                            icon: Icons.search,
                            onClick: () {}, //!
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                          RoundIconButton(
                            icon: Icons.add,
                            onClick: () {}, //!
                            backgroundColor:
                                Theme.of(context).colorScheme.onSecondary,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 25),
                      height: 122,
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(left: 20, right: 10),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return StoryTile(
                            profileUrl: index == 0
                                ? 'https://data.whicdn.com/images/322027365/original.jpg?t=1541703413'
                                : 'https://i.pinimg.com/originals/28/c5/54/28c55499f5401efd54ff75339bc63331.jpg',
                            name: 'Jay',
                            isYou: index == 0,
                          );
                        },
                        itemCount: 3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: getChatRoomsList(),
                  ),
                  Expanded(
                    child: Container(
                      height: 500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onClick;
  final Color backgroundColor;

  const RoundIconButton({
    Key? key,
    required this.icon,
    required this.onClick,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        child: Icon(
          icon,
          color: Colors.white,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
          border: Border.all(
            width: 1,
            color: Theme.of(context).primaryColor.withOpacity(0.35),
          ),
        ),
      ),
    );
  }
}
