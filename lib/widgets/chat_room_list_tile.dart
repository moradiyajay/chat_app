import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../helpers/database_service.dart';

class ChatRoomListTile extends StatefulWidget {
  final String lastMessage;
  final String chatRoomId;
  final String myUid;
  final DateTime dateTime;
  final Function({
    required String chatWithUid,
    required String chatWithUsername,
    required String profileUrl,
  }) onClick;
  const ChatRoomListTile(
      {required this.lastMessage,
      required this.chatRoomId,
      required this.myUid,
      required this.onClick,
      required this.dateTime,
      Key? key})
      : super(key: key);

  @override
  _ChatRoomListTileState createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {
  String profileUrl = "";
  String displayName = "";
  String chatWithUsername = "";
  String chatWithUid = "";

  getThisUserInfo() async {
    chatWithUid =
        widget.chatRoomId.replaceFirst(widget.myUid, "").replaceFirst("_", "");
    DocumentSnapshot documentSnapshot =
        await DataBase().getUserInfo(chatWithUid);
    Map<String, dynamic> docMap =
        documentSnapshot.data() as Map<String, dynamic>;
    displayName = "${docMap["displayName"]}";
    profileUrl = "${docMap["profileURL"]}";
    chatWithUsername = "${docMap["username"]}";
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
        displayName,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        widget.lastMessage,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.black54,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Container(
          //   decoration: BoxDecoration(
          //     color: Colors.green.shade400,
          //     shape: BoxShape.circle,
          //   ),
          //   padding: const EdgeInsets.all(6),
          //   child: const Text(
          //     '1',
          //     style: TextStyle(
          //       fontWeight: FontWeight.w500,
          //       color: Colors.white,
          //     ),
          //   ),
          // ),
          Text(
            DateFormat('hh:mm aa').format(widget.dateTime),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black45,
            ),
          ),
        ],
      ),
      onTap: () => widget.onClick(
        chatWithUid: chatWithUid,
        chatWithUsername: chatWithUsername,
        profileUrl: profileUrl,
      ),
    );
  }
}
