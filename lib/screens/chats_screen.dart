// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, curly_braces_in_flow_control_structures

import 'dart:ui';

import 'package:chat_app/components/round_icon.dart';
import 'package:chat_app/screens/story_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';

import '../helpers/database_service.dart';
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
  late User? _user;

  late Stream<QuerySnapshot> userStream;
  late Stream<QuerySnapshot> storyStream;
  late Stream<QuerySnapshot> chatRoomStream;
  String myUid = '';
  bool isLogingOut = false;
  bool isSearchOn = false;
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();

  void onSearchBtnClick(String username) async {
    // ! update
    if (username == 'myUsername') return;
    setState(() {
      isSearching = true;
    });
    userStream = await DataBase().getUserByUserName(username);
  }

  void listTileClick({
    required String chatWithUid,
    required String chatWithUsername,
    required String profileUrl,
  }) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, _, __) => ChatRoomScreen(
          chatWithUsername: chatWithUsername,
          chatWithUid: chatWithUid,
          myUid: myUid,
          profileUrl: profileUrl,
        ),
      ),
    );
  }

  initializeStreams() async {
    DataBase db = DataBase();
    chatRoomStream = db.getChatRooms();
    userStream = db.getUserByUserName(myUid);
    storyStream = db.getUsers();
    setState(() {});
  }

  Widget _storyList() {
    return StreamBuilder<QuerySnapshot>(
      stream: storyStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        List<DocumentSnapshot> docs = snapshot.data!.docs;
        final myDocIndex = docs.indexWhere((user) => user.id == _user!.uid);

        if (myDocIndex != -1) {
          final DocumentSnapshot myDoc = docs[myDocIndex];
          docs.removeAt(myDocIndex);
          docs.insert(0, myDoc);
          docs.removeWhere(
              (user) => user['story'] == null && user.id != _user!.uid);
        }
        return Container(
          margin: EdgeInsets.only(top: 10, bottom: 25),
          height: 122,
          child: ListView.builder(
            shrinkWrap: false,
            padding: EdgeInsets.only(left: 20, right: 10),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return StoryTile(
                profileUrl: docs[index]['profileURL'],
                name: index == 0 ? 'Your Story' : docs[index]['displayName'],
                isYou: index == 0 && docs[index]['story'] == null,
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, _, __) {
                        return StoryScreen(
                          profileUrl: docs[index]['profileURL'],
                          displayName: docs[index]['displayName'],
                          viewStory: docs[index]['story'] != null,
                          storyfileUrl: docs[index]['story'] ?? '',
                        );
                      },
                    ),
                  );
                },
              );
            },
            itemCount: docs.length,
          ),
        );
      },
    );
  }

  Widget getChatRoomsList() {
    List<Widget> _getList(List<DocumentSnapshot> docs) {
      List<Widget> list = [];
      for (var doc in docs) {
        list.add(ChatRoomListTile(
          lastMessage: doc['lastMessage'],
          chatRoomId: doc.id,
          dateTime: (doc['lastTs'] as Timestamp).toDate(),
          myUid: myUid,
          onClick: listTileClick,
          key: ValueKey(doc.id),
        ));
      }
      return list;
    }

    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return snapshot.hasData
            ? snapshot.data!.docs.isEmpty
                ? Center(child: Text('Start Chating'))
                : Column(
                    children: [
                      ..._getList(snapshot.data!.docs),
                    ],
                  )
            : const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget searchUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: userStream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                        chatWithUsername: ds["username"],
                        chatWithUid: ds["userID"],
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

  String greetings() {
    int hour = DateTime.now().hour;
    if (hour < 12) {
      return "Good Mornig";
    } else if (hour >= 12 && hour < 18)
      return " Good Afternoon";
    else
      return " Good Evening";
  }

  logOut(FirebaseServiceProvider firebaseServiceProvider) async {
    setState(() {
      isLogingOut = !isLogingOut;
    });
    await firebaseServiceProvider.logOut();
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
    _user = FirebaseServiceProvider().user;
    myUid = _user!.uid;
    initializeStreams();
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
              pinned: true,
              backgroundColor: Theme.of(context).colorScheme.background,
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
                  child: Row(
                    textBaseline: TextBaseline.alphabetic,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    children: [
                      Text(
                        'Chats',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
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
                          _user!.photoURL ??
                              'https://data.whicdn.com/images/322027365/original.jpg?t=1541703413', //!
                        ),
                      ),
                      title: Text(
                        greetings(),
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          _user!.displayName ?? 'Alexie Blender', // !
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          RoundIconButton(
                            icon: Icons.search,
                            onClick: () async {
                              userStream =
                                  DataBase().getUserByUserName('jaymoradiya18');
                              setState(() {
                                isSearchOn = !isSearchOn;
                              });
                            }, //!
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                          RoundIconButton(
                            icon: Icons.add,
                            onClick: () {}, //!
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                          ),
                        ],
                      ),
                    ),
                    _storyList()
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate.fixed(
                [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    color: Colors.white,
                    child: isSearchOn ? searchUserList() : getChatRoomsList(),
                  ),
                  Container(
                    height: 500,
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
