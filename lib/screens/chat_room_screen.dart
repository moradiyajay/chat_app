import 'package:chat_app/provider/database_service.dart';
import 'package:chat_app/widgets/custom_app_bar.dart';
import 'package:chat_app/widgets/recive_message.dart';
import 'package:chat_app/widgets/send_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/components/media_icon.dart';
import 'package:intl/intl.dart';
import '../widgets/message_input_field.dart';

class ChatRoomScreen extends StatefulWidget {
  final String chatWithUsername, myUsername, profileUrl;

  const ChatRoomScreen(this.chatWithUsername, this.myUsername, this.profileUrl);

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  String chatRoomId = "";
  late Stream messageStream;
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
    checkAndCreateChatRoom();
    getPreviousMessages();
  }

  checkAndCreateChatRoom() async {
    await DataBase().createChatRoom(chatRoomId, {
      'lastMessage': '',
      'lastTs': DateTime.now(),
      'lastSendBy': widget.myUsername,
      'users': [widget.myUsername, widget.chatWithUsername],
    });
  }

  getPreviousMessages() {
    messageStream = DataBase().getAllMessages(chatRoomId);
  }

  Widget messageList() {
    return StreamBuilder<QuerySnapshot>(
      stream: messageStream as Stream<QuerySnapshot>,
      builder: (context, snapshots) {
        if (snapshots.hasData) {
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 230),
            reverse: true,
            itemBuilder: (ctx, index) {
              DocumentSnapshot ds = snapshots.data!.docs[index];
              return ds['sendBy'] == widget.myUsername
                  ? SendMessage(ds: ds)
                  : ReciveMessage(ds: ds);
            },
            itemCount: snapshots.data!.docs.length,
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  onSendClick(String sendMessage) {
    if (sendMessage.isEmpty) return;
    String message = sendMessage;
    controller.clear();
    var timeStamp = DateTime.now();

    Map<String, dynamic> messageInfo = {
      'message': message,
      'ts': timeStamp,
      'sendBy': widget.myUsername,
    };

    DataBase().addMessage(chatRoomId, messageInfo).then((value) async {
      Map<String, dynamic> lastMessageInfo = {
        'lastMessage': message,
        'lastTs': timeStamp,
        'lastSendBy': widget.myUsername,
        'users': [widget.myUsername, widget.chatWithUsername],
      };
      await DataBase().updateLastMessgae(chatRoomId, lastMessageInfo);
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color photoColor = Color.fromRGBO(52, 30, 255, 1);
    const Color fileColor = Color.fromRGBO(159, 22, 255, 1);
    const Color contactColor = Color.fromRGBO(255, 119, 44, 1);
    const Color locationColor = Color.fromRGBO(255, 95, 150, 1);
    EdgeInsets appBarPadding = const EdgeInsets.only(top: 15);
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.975),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: CustomAppBar(
          appBarPadding: appBarPadding,
          username: widget.chatWithUsername,
          profileUrl: widget.profileUrl,
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            messageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 32),
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
                  mainAxisSize: MainAxisSize.min,
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
      ),
    );
  }
}
