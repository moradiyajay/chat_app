import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../helpers/database_service.dart';
import '../provider/firebase_service.dart';
import 'chat_room_screen.dart';
import 'start_screen.dart';
import '../widgets/chat_room_list_tile.dart';
import '../widgets/story_tile.dart';
import '../components/round_icon.dart';
import '../screens/search_screen.dart';
import '../screens/story_screen.dart';

class ChatsScreen extends StatefulWidget {
  static String routeName = '/chats';
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  late User? _user;

  late Stream<QuerySnapshot> storyStream;
  late Stream<QuerySnapshot> chatRoomStream;
  String myUid = '';
  bool isLogingOut = false;
  bool isSearchOn = false;
  bool isSearching = false;
  bool showManageTools = false;
  TextEditingController searchController = TextEditingController();

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
    storyStream = db.getUsers();
    setState(() {});
  }

  Widget _storyList() {
    return StreamBuilder<QuerySnapshot>(
      stream: storyStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            alignment: Alignment.center,
            height: 122,
            margin: const EdgeInsets.only(top: 10, bottom: 25),
            child: const CircularProgressIndicator(),
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
          margin: const EdgeInsets.only(top: 10, bottom: 25),
          height: 122,
          child: ListView.builder(
            shrinkWrap: false,
            padding: const EdgeInsets.only(left: 20, right: 10),
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
        list.add(
          GestureDetector(
            onLongPress: onManageClick,
            child: ChatRoomListTile(
              lastMessage: doc['lastMessage'],
              chatRoomId: doc.id,
              dateTime: (doc['lastTs'] as Timestamp).toDate(),
              myUid: myUid,
              onClick: listTileClick,
              key: ValueKey(doc.id),
            ),
          ),
        );
      }
      return list;
    }

    return StreamBuilder(
      stream: DataBase().getChatRooms(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 200,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          );
        }
        return snapshot.hasData
            ? snapshot.data!.docs.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        const Text(
                          'No Disscution yet...',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          'Send message to your friends',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.black54,
                          ),
                        ),
                        SvgPicture.asset(
                          'images/begin_chat.svg',
                          width: 200,
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      ..._getList(snapshot.data!.docs),
                    ],
                  )
            : const Center(child: CircularProgressIndicator());
      },
    );
  }

  String greetings() {
    int hour = DateTime.now().hour;
    if (hour < 12) {
      return "Good Mornig";
    } else if (hour >= 12 && hour < 18) {
      return " Good Afternoon";
    } else {
      return " Good Evening";
    }
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
        pageBuilder: (ctx, _, __) => const StartScreen(),
      ),
    );
  }

  onManageClick() {
    setState(() {
      showManageTools = !showManageTools;
    });
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

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 330,
          collapsedHeight: 70,
          pinned: true,
          backgroundColor: Theme.of(context).colorScheme.background,
          elevation: 0,
          flexibleSpace: FlexibleSpaceBar(
            title: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),
              child: Row(
                textBaseline: TextBaseline.alphabetic,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                children: [
                  const Text(
                    'Chats',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: onManageClick,
                    child: const Text(
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
                const SizedBox(height: 10),
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      _user!.photoURL ??
                          'https://ui-avatars.com/api/?name=chat+app&background=random&rounded=true&size=128&format=png',
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
                      _user!.displayName ?? 'user',
                      style: const TextStyle(
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
                      Hero(
                        tag: "searchIcon",
                        child: RoundIconButton(
                          icon: Icons.search,
                          onClick: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(pageBuilder: (context, _, __) {
                                return const SearchScreen();
                              }, transitionsBuilder: (context,
                                  Animation<double> animation, _, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              }),
                            );

                            setState(() {
                              isSearchOn = !isSearchOn;
                            });
                          },
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                      ),
                      RoundIconButton(
                        icon: Icons.add,
                        onClick: () async {
                          await FirebaseServiceProvider().logOut();
                        }, // only for show
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
              if (showManageTools)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: 100,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white,
                                Theme.of(context).primaryColor.withOpacity(0.1)
                              ],
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 16,
                          ),
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Today ${DateFormat('h:mm aa').format(DateTime.now())} ',
                            style: const TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      RoundIconButton(
                        icon: Icons.push_pin,
                        onClick: () {},
                        backgroundColor: Colors.green.shade400,
                      ),
                      RoundIconButton(
                        icon: Icons.volume_off_sharp,
                        onClick: () {},
                        backgroundColor:
                            Theme.of(context).primaryColor.withOpacity(0.7),
                      ),
                      RoundIconButton(
                        icon: CupertinoIcons.delete_solid,
                        onClick: () {},
                        backgroundColor: Colors.red.shade400,
                      ),
                    ],
                  ),
                ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                color: Colors.white,
                child: getChatRoomsList(),
              ),
              Container(
                color: Colors.white,
                height: 500,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
