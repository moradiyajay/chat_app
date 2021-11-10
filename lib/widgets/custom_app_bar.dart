import 'package:chat_app/components/round_icon.dart';
import 'package:chat_app/screens/chats_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(profileUrl),
          ),
          const SizedBox(width: 20),
          Text(
            username,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        RoundIconButton(
          icon: Icons.phone,
          onClick: () {},
          backgroundColor: Colors.green.shade300,
        ),
      ],
    );

    //   return AppBar(
    //     titleSpacing: 0,
    //     title: Padding(
    //       padding: appBarPadding,
    //       child: Row(
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: [
    //           CircleAvatar(
    //             backgroundImage: NetworkImage(profileUrl),
    //           ),
    //           const SizedBox(width: 20),
    //           Text(
    //             username,
    //             style: const TextStyle(
    //               color: Colors.black,
    //               fontSize: 18,
    //               fontWeight: FontWeight.bold,
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //     leading: Padding(
    //       padding: appBarPadding,
    //       child: IconButton(
    //         padding: EdgeInsets.zero,
    //         highlightColor: Colors.transparent,
    //         splashColor: Colors.transparent,
    //         icon: const Icon(
    //           Icons.arrow_back_rounded,
    //           color: Colors.black,
    //         ),
    //         onPressed: () => Navigator.pop(context),
    //       ),
    //     ),
    //     actions: [
    //       RoundIconButton(
    //         icon: Icons.phone,
    //         onClick: () {},
    //         backgroundColor: Colors.green.shade300,
    //       ),
    //     ],

    //     // automaticallyImplyLeading: false,
    //     elevation: 5,
    //     backgroundColor: Colors.white,
    //     shadowColor: Colors.black12,
    //     // shape: const RoundedRectangleBorder(
    //     //   borderRadius: BorderRadius.vertical(
    //     //     bottom: Radius.circular(20),
    //     //   ),
    //     // ),
    //   );
  }
}
