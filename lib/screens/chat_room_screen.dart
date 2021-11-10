// ignore_for_file: unnecessary_string_escapes
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

import '../helpers/database_service.dart';
import '../widgets/message.dart';
import '../components/media_icon.dart';
import '../widgets/message_input_field.dart';

enum MessageType {
  Text,
  Image,
  Document,
  Video,
  Contact,
  Location,
  TextImage,
}

class ChatRoomScreen extends StatefulWidget {
  final String chatWithUsername;
  final String profileUrl;
  final String chatWithUid;
  final String myUid;

  const ChatRoomScreen({
    required this.chatWithUsername,
    required this.chatWithUid,
    required this.myUid,
    required this.profileUrl,
    Key? key,
  }) : super(key: key);

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  String _chatRoomId = "";
  MessageType _messageType = MessageType.Text;
  late File _previewImageFile;
  late String _uploadedFileUrl;
  late Stream _messageStream;
  bool _isSelecting = false;
  TextEditingController controller = TextEditingController();

  String getChatRoomIdByUid(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  void initState() {
    super.initState();
    _chatRoomId = getChatRoomIdByUid(widget.chatWithUid, widget.myUid);
    checkAndCreateChatRoom();
    getPreviousMessages();
  }

  void checkAndCreateChatRoom() async {
    await DataBase().createChatRoom(_chatRoomId, {
      'lastMessage': '',
      'lastTs': DateTime.now(),
      'lastSendBy': widget.myUid,
      'users': [widget.myUid, widget.chatWithUid],
    });
  }

  getPreviousMessages() {
    _messageStream = DataBase().getAllMessages(_chatRoomId);
  }

  Widget messageList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _messageStream as Stream<QuerySnapshot>,
      builder: (context, snapshots) {
        return snapshots.hasData
            ? ListView.builder(
                padding: EdgeInsets.only(bottom: _isSelecting ? 210 : 100),
                reverse: true,
                itemBuilder: (ctx, index) {
                  DocumentSnapshot ds = snapshots.data!.docs[index];
                  return SendMessage(
                    ds: ds,
                    messageType: MessageType.values[ds['type'] as int],
                    isMe: ds['sendBy'] == widget.myUid,
                    key: ValueKey(ds.id),
                  );
                },
                itemCount: snapshots.data!.docs.length,
              )
            : const Center(child: CircularProgressIndicator());
      },
    );
  }

  sendMessage(String sendMessage) async {
    if (sendMessage.isEmpty && _messageType == MessageType.Text) return;
    FocusScope.of(context).unfocus();
    String message = sendMessage;

    if (sendMessage.isNotEmpty && _messageType == MessageType.Image) {
      _messageType == MessageType.TextImage;
    }

    if (_messageType == MessageType.Image ||
        _messageType == MessageType.TextImage) {
      String imageUrl =
          await DataBase().uploadFile(_previewImageFile, _chatRoomId);
      _uploadedFileUrl = imageUrl;
    }

    controller.clear();
    var timeStamp = Timestamp.now();
    try {
      Map<String, dynamic> messageInfo = {
        'message': message,
        'ts': timeStamp,
        'sendBy': widget.myUid,
        'fileUrl': _uploadedFileUrl,
        'type': _messageType.index,
      };

      await DataBase().addMessage(_chatRoomId, messageInfo);
      Map<String, dynamic> lastMessageInfo = {
        'lastMessage': message,
        'lastTs': timeStamp,
        'lastSendBy': widget.myUid,
        'fileUrl': _uploadedFileUrl,
        'type': _messageType.index,
        'users': [widget.myUid, widget.chatWithUid],
      };
      await DataBase().updateLastMessgae(_chatRoomId, lastMessageInfo);
      setState(() {
        _messageType = MessageType.Text;
      });
    } catch (error) {
      setState(() {
        controller.text = message;
      });
    }
  }

  _imagePicker() async {
    FocusScope.of(context).unfocus();
    final ImagePicker _picker = ImagePicker();
    ImageSource? imageSource;
    await showModalBottomSheet(
      context: context,
      constraints: const BoxConstraints(maxHeight: 120),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MediaIcon(
                backgroundColor: Colors.black,
                text: 'Camera',
                onClick: () {
                  imageSource = ImageSource.camera;
                  Navigator.pop(context);
                },
                icon: CupertinoIcons.camera_fill,
              ),
              const SizedBox(width: 20),
              MediaIcon(
                backgroundColor: Colors.pinkAccent,
                text: 'Gallery',
                onClick: () {
                  imageSource = ImageSource.gallery;
                  Navigator.pop(context);
                },
                icon: CupertinoIcons.photo,
              ),
            ],
          ),
        );
      },
    );
    if (imageSource == null) return;

    final XFile? imageFile = await _picker.pickImage(
        source: imageSource ?? ImageSource.camera, imageQuality: 50);

    if (imageFile == null) return;
    setState(() {
      _previewImageFile = File(imageFile.path);
      _messageType = MessageType.Image;
    });
  }

  _filePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      // ignore: unused_local_variable
      String? path = result.files.first.path;
      File file = File(path ?? '');
      String downloadUrl = await DataBase().uploadFile(file, _chatRoomId);
      print(downloadUrl);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    const Color photoColor = Color.fromRGBO(52, 30, 255, 1);
    const Color fileColor = Color.fromRGBO(159, 22, 255, 1);
    const Color contactColor = Color.fromRGBO(255, 119, 44, 1);
    const Color locationColor = Color.fromRGBO(255, 95, 150, 1);

    final Size size = MediaQuery.of(context).size;
    // EdgeInsets appBarPadding = const EdgeInsets.only(top: 15);
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.975),
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 5,
        shadowColor: Colors.black12,
        backgroundColor: _messageType != MessageType.Text
            ? Colors.black.withOpacity(0.2)
            : Colors.white,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: CircleAvatar(
                backgroundImage: NetworkImage(widget.profileUrl),
              ),
            ),
            const SizedBox(width: 20),
            Text(
              widget.chatWithUsername,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          MediaIcon(
            backgroundColor: Theme.of(context).colorScheme.primary,
            text: '',
            onClick: () {},
            padding: 5,
            icon: CupertinoIcons.video_camera_solid,
          ),
          const SizedBox(
            width: 8,
          ),
          MediaIcon(
            backgroundColor: Colors.green.shade400,
            text: '',
            onClick: () {},
            padding: 5,
            icon: CupertinoIcons.phone_solid,
          ),
          const SizedBox(
            width: 8,
          )
        ],
        foregroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Container(
            color: Theme.of(context).colorScheme.background.withOpacity(0.5),
            width: double.infinity,
            child: _messageType == MessageType.Image
                // Todo chage image preview to all file preview
                ? Image.file(
                    _previewImageFile,
                    fit: BoxFit.fill,
                    alignment: Alignment.center,
                    height: size.height,
                  )
                : messageList(),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              width: size.width,
              decoration: BoxDecoration(
                color: Colors.white
                    .withOpacity(_messageType != MessageType.Text ? 0.4 : 1),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(25),
                ),
                boxShadow: const [
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
                    margin: EdgeInsets.only(
                        bottom: _isSelecting ? 30 : 0, left: 16, right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MediaIcon(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          text: '',
                          onClick: () {},
                          icon: Icons.mic_none_outlined,
                        ),
                        MessageInputField(
                          conroller: controller,
                          onSendClick: sendMessage,
                          onAddClick: () {
                            setState(() {
                              _isSelecting = !_isSelecting;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  if (_isSelecting)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        MediaIcon(
                          backgroundColor: photoColor,
                          text: 'Image',
                          onClick: _imagePicker,
                          icon: CupertinoIcons.photo,
                        ),
                        MediaIcon(
                            backgroundColor: fileColor,
                            text: 'Document',
                            onClick: _filePicker,
                            icon: CupertinoIcons.doc_fill),
                        MediaIcon(
                          backgroundColor: contactColor,
                          text: 'Contact',
                          onClick: () {},
                          icon: CupertinoIcons.person,
                        ),
                        MediaIcon(
                          backgroundColor: locationColor,
                          text: 'Location',
                          onClick: () {},
                          icon: CupertinoIcons.location,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          if (_messageType != MessageType.Text)
            Positioned(
              top: 8,
              right: 8,
              child: MediaIcon(
                backgroundColor: Colors.black,
                icon: CupertinoIcons.delete,
                text: '',
                onClick: () {
                  setState(() {
                    _messageType = MessageType.Text;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }
}
