import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../helpers/database_service.dart';

class ChatRoomListTile extends StatefulWidget {
  final String lastMessage;
  final String chatRoomId;
  final String myUsername;
  final DateTime dateTime;
  final Function onClick;
  const ChatRoomListTile(
      {required this.lastMessage,
      required this.chatRoomId,
      required this.myUsername,
      required this.onClick,
      required this.dateTime,
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
    return ListTile(
      tileColor: Colors.white,
      leading: CircleAvatar(
        backgroundImage: NetworkImage(profileUrl),
        minRadius: 23,
        maxRadius: 24,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 5),
      title: Text(
        name,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        widget.lastMessage,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Colors.black54,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.green.shade400,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(6),
            child: const Text(
              '1',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          Text(
            DateFormat('hh:mm aa').format(widget.dateTime),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black45,
            ),
          ),
        ],
      ),
      onTap: () => widget.onClick(username, profileUrl),
    );
  }
}
