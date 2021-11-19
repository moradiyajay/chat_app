import 'package:chat_app/helpers/database_service.dart';
import 'package:chat_app/screens/chat_room_screen.dart';
import 'package:chat_app/widgets/rectangle_search_field.dart';
import 'package:chat_app/widgets/search_list_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchScreen extends StatefulWidget {
  static String routeName = '/search';

  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  late Stream<QuerySnapshot> userStream;
  late String myUid;
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    myUid = FirebaseAuth.instance.currentUser!.uid;
  }

  void onSearchBtnClick(String username) async {
    // ! update
    if (username == 'myUsername') return;
    setState(() {
      isSearching = true;
    });
    userStream = DataBase().getUserByUserName(username);
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

  Widget searchUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: userStream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return snapshot.hasData
            ? snapshot.data!.docs.isEmpty
                ? const Center(child: Text('No User Found'))
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: RectangleSearchField(
          onSearchBtnClick: onSearchBtnClick,
          searchController: _controller,
          onBackBtnClick: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Hero(
        tag: "results",
        child: Container(
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
          margin: const EdgeInsets.only(top: 20),
          padding:
              const EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              if (isSearching)
                const Text(
                  'Results',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
              !isSearching
                  ? Expanded(
                      child: SvgPicture.asset(
                        'images/people_search.svg',
                        width: size.width * 0.6,
                      ),
                    )
                  : searchUserList(),
            ],
          ),
        ),
      ),
    );
  }
}
