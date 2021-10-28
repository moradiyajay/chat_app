import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key? key,
    required this.appBarPadding,
    required this.username,
    required this.profileUrl,
  }) : super(key: key);

  final EdgeInsets appBarPadding;
  final String username;
  final String profileUrl;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      title: Padding(
        padding: appBarPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(profileUrl),
            ),
            const SizedBox(width: 20),
            Text(
              username,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      leading: Padding(
        padding: appBarPadding,
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      actions: [
        IconButton(
          padding: appBarPadding.copyWith(right: 24),
          onPressed: () {},
          icon: const Icon(Icons.phone),
        ),
      ],
      automaticallyImplyLeading: false,
      elevation: 5,
      shadowColor: Colors.black12,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
    );
  }
}
