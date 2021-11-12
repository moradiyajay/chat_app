// ignore_for_file: unnecessary_string_escapes
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:contact_picker/contact_picker.dart';

import '../helpers/database_service.dart';
import '../widgets/message.dart';
import '../components/media_icon.dart';
import '../widgets/message_input_field.dart';

enum MessageType {
  Text,
  Image,
  Document,
  Contact,
  Location,
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
  late File _previewFile;
  late String _uploadedFileUrl = '';
  late String _previewFileName = '';
  late Stream _messageStream;
  bool _isSelecting = false;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _chatRoomId = getChatRoomIdByUid(widget.chatWithUid, widget.myUid);
    checkAndCreateChatRoom();
    getPreviousMessages();
  }

  String getChatRoomIdByUid(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  void _onDelete() {
    setState(() {
      _previewFileName = '';
      _uploadedFileUrl = '';
      _previewFile.delete();
      _messageType = MessageType.Text;
    });
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

  onMessageClick(String message, String fileUrl) {}

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
                    onTap: onMessageClick,
                  );
                },
                itemCount: snapshots.data!.docs.length,
              )
            : const Center(child: CircularProgressIndicator());
      },
    );
  }

  _sendMessage(String sendMessage) async {
    if (sendMessage.isEmpty && _messageType == MessageType.Text) return;
    FocusScope.of(context).unfocus();
    String message = sendMessage;
    MessageType tmpMessageType = _messageType;

    controller.clear();
    var timeStamp = Timestamp.now();

    if (tmpMessageType != MessageType.Text) {
      try {
        setState(() {
          _messageType = MessageType.Text;
        });
        // ! set metadata for more info
        String imageUrl = await DataBase().uploadFile(
          _previewFile,
          _chatRoomId,
          SettableMetadata(customMetadata: {
            'name': _previewFileName,
          }),
        );
        _uploadedFileUrl = imageUrl;
      } on FirebaseStorage catch (error) {
        setState(() {
          controller.text = message;
          _messageType = tmpMessageType;
          _previewFileName = '';
          _uploadedFileUrl = '';
          _previewFile.delete();
        });
        // ignore: avoid_print
        print(error);
        return;
      }
    }

    try {
      Map<String, dynamic> messageInfo = {
        'message': message,
        'ts': timeStamp,
        'sendBy': widget.myUid,
        'fileUrl': _uploadedFileUrl,
        'type': tmpMessageType.index,
      };

      await DataBase().addMessage(_chatRoomId, messageInfo);
      Map<String, dynamic> lastMessageInfo = {
        'lastMessage': message,
        'lastTs': timeStamp,
        'lastSendBy': widget.myUid,
        'fileUrl': _uploadedFileUrl,
        'type': tmpMessageType.index,
        'users': [widget.myUid, widget.chatWithUid],
      };
      await DataBase().updateLastMessgae(_chatRoomId, lastMessageInfo);
      setState(() {
        _messageType = MessageType.Text;
        _previewFileName = '';
        _uploadedFileUrl = '';
        _previewFile.delete();
      });
    } catch (error) {
      setState(() {
        controller.text = message;
        _previewFileName = '';
        _uploadedFileUrl = '';
        _previewFile.delete();
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
      _previewFile = File(imageFile.path);

      var _splitPath = _previewFile.path.split('/');
      _previewFileName = _splitPath[_splitPath.length - 1];
      _messageType = MessageType.Image;
    });
  }

  _filePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result == null) return;

    String? path = result.files.first.path;
    _previewFile = File(path ?? '');
    var _splitPath = path!.split('/');
    _previewFileName = _splitPath[_splitPath.length - 1];
    setState(() {
      _messageType = MessageType.Document;
    });
  }

  _contactPicker() async {
    final ContactPicker _contactPicker = ContactPicker();
    Contact contact = await _contactPicker.selectContact();
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
        backgroundColor: Colors.white,
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
          const SizedBox(width: 8),
          MediaIcon(
            backgroundColor: Colors.green.shade400,
            text: '',
            onClick: () {},
            padding: 5,
            icon: CupertinoIcons.phone_solid,
          ),
          const SizedBox(width: 8)
        ],
        foregroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Container(
            color: _messageType == MessageType.Image
                ? Colors.black
                : Theme.of(context).colorScheme.background.withOpacity(0.5),
            width: double.infinity,
            child: _messageType == MessageType.Image
                // Todo chage image preview to all file preview
                ? Container(
                    constraints: BoxConstraints(
                      minHeight: size.height * 0.4,
                      maxHeight: size.height * 0.8,
                    ),
                    child: Image.file(
                      _previewFile,
                      fit: BoxFit.fill,
                      alignment: Alignment.center,
                      height: size.height,
                    ),
                  )
                : messageList(),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              width: size.width,
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
                  // Document Preview
                  if (_messageType == MessageType.Document)
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            CupertinoIcons.doc_fill,
                            color: Colors.white.withOpacity(0.7),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _previewFileName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: _onDelete,
                            child: Icon(
                              CupertinoIcons.delete_solid,
                              color: Colors.red.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                          onSendClick: _sendMessage,
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
                          onClick: _contactPicker,
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
                icon: CupertinoIcons.delete_solid,
                text: '',
                onClick: _onDelete,
              ),
            ),
        ],
      ),
    );
  }
}
