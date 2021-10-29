import 'package:chat_app/provider/database_service.dart';
import 'package:chat_app/screens/chat_room_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatRoomListTile extends StatefulWidget {
  final String lastMessage, chatRoomId, myUsername;
  final Function onClick;
  const ChatRoomListTile(
      {required this.lastMessage,
      required this.chatRoomId,
      required this.myUsername,
      required this.onClick,
      Key? key})
      : super(key: key);

  @override
  _ChatRoomListTileState createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {
  String profileUrl = "";
  String name = "";
  String username = "";

  getThisUserInfo() async {
    username =
        widget.chatRoomId.replaceAll(widget.myUsername, "").replaceAll("_", "");
    QuerySnapshot querySnapshot = await DataBase().getUserInfo(username);
    name = "${querySnapshot.docs[0]["displayName"]}";
    profileUrl = "${querySnapshot.docs[0]["profileURL"]}";
    setState(() {});
  }

  @override
  void initState() {
    getThisUserInfo();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ChatRoomListTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    getThisUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onClick(username, profileUrl),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(profileUrl),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 3),
                Text(widget.lastMessage)
              ],
            )
          ],
        ),
      ),
    );
  }
}
