import 'package:chat_app/widgets/custom_app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/components/media_icon.dart';
import '../widgets/message_input_field.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatRoomScreen extends StatefulWidget {
  final String chatWithUsername, myUsername;
  ChatRoomScreen(this.chatWithUsername, this.myUsername);

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  String chatRoomId = "";
  String messageID = "";
  TextEditingController controller = TextEditingController();

  getChatRoomIdByUsernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  void initState() {
    super.initState();
    chatRoomId =
        getChatRoomIdByUsernames(widget.chatWithUsername, widget.myUsername);
    getPreviousMessages();
  }

  getPreviousMessages() {}

  onSendClick(String sendMessage) {
    String message = sendMessage;
    controller.clear();
    var timeStamp = DateTime.now();

    Map<String, dynamic> messageInfo = {
      'message': message,
      'ts': timeStamp,
      'sendBy': widget.myUsername,
    };
  }

  @override
  Widget build(BuildContext context) {
    const Color photoColor = Color.fromRGBO(52, 30, 255, 1);
    const Color fileColor = Color.fromRGBO(159, 22, 255, 1);
    const Color contactColor = Color.fromRGBO(255, 119, 44, 1);
    const Color locationColor = Color.fromRGBO(255, 95, 150, 1);
    EdgeInsets appBarPadding = const EdgeInsets.only(top: 20);
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.975),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: CustomAppBar(
          appBarPadding: appBarPadding,
          username: widget.chatWithUsername,
          profileUrl: '',
        ),
      ),
      body: Stack(
        children: [
          Container(),
          Positioned(
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 32),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 5,
                    color: Colors.black12,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin:
                        const EdgeInsets.only(bottom: 30, left: 16, right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MediaIcon(
                          backgroundColor: Colors.black87,
                          text: '',
                          onClick: () {},
                          icon: Icons.mic_none_outlined,
                        ),
                        MessageInputField(
                          conroller: controller,
                          onSendClick: onSendClick,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      MediaIcon(
                        backgroundColor: photoColor,
                        text: 'Image',
                        onClick: () {},
                        icon: Icons.photo_outlined,
                      ),
                      MediaIcon(
                          backgroundColor: fileColor,
                          text: 'File',
                          onClick: () {},
                          icon: Icons.attach_file_outlined),
                      MediaIcon(
                        backgroundColor: contactColor,
                        text: 'Contact',
                        onClick: () {},
                        icon: Icons.person_outline,
                      ),
                      MediaIcon(
                        backgroundColor: locationColor,
                        text: 'Location',
                        onClick: () {},
                        icon: Icons.location_on_outlined,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
