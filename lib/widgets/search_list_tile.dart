import 'package:flutter/material.dart';

class SearchListTile extends StatelessWidget {
  final String profileUrl;
  final String name;
  final String username;
  final String email;

  SearchListTile(
      {required this.profileUrl,
      required this.name,
      required this.username,
      required this.email});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // var chatRoomId = getChatRoomIdByUsernames(myUserName, username);
        // Map<String, dynamic> chatRoomInfoMap = {
        //   "users": [myUserName, username]
        // };
        // DatabaseMethods().createChatRoom(chatRoomId, chatRoomInfoMap);
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => ChatScreen(username, name)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.network(
                profileUrl,
                height: 40,
                width: 40,
              ),
            ),
            SizedBox(width: 12),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(name), Text(email)])
          ],
        ),
      ),
    );
  }
}
