import 'package:flutter/material.dart';

class SearchListTile extends StatelessWidget {
  final String profileUrl;
  final String name;
  final String chatWithUsername;
  final String chatWithUid;
  final String email;
  final Function({
    required String chatWithUid,
    required String chatWithUsername,
    required String profileUrl,
  }) onClick;
  const SearchListTile({
    Key? key,
    required this.profileUrl,
    required this.name,
    required this.chatWithUid,
    required this.chatWithUsername,
    required this.email,
    required this.onClick,
  }) : super(key: key);

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
        email,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Colors.black54,
        ),
      ),
      onTap: () => onClick(
        chatWithUid: chatWithUid,
        chatWithUsername: chatWithUsername,
        profileUrl: profileUrl,
      ),
    );
  }
}
