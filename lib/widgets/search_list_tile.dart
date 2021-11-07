import 'package:flutter/material.dart';

class SearchListTile extends StatelessWidget {
  final String profileUrl;
  final String name;
  final String username;
  final String email;
  final Function onClick;

  const SearchListTile({
    Key? key,
    required this.profileUrl,
    required this.name,
    required this.username,
    required this.email,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onClick(username, profileUrl),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
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
            const SizedBox(width: 12),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(name), Text(email)])
          ],
        ),
      ),
    );
  }
}
