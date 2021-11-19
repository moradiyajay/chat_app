import 'dart:io';

import 'package:chat_app/components/media_icon.dart';
import 'package:chat_app/helpers/database_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class StoryScreen extends StatefulWidget {
  static String routeName = '/story';

  final String displayName;
  final String profileUrl;
  final String storyfileUrl;
  final bool viewStory;
  const StoryScreen({
    required this.displayName,
    required this.profileUrl,
    required this.viewStory,
    this.storyfileUrl = '',
    Key? key,
  }) : super(key: key);

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  late File _previewFile;
  bool _imageSelected = false;
  bool _uploading = false;

  _selectImage() async {
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
      _imageSelected = true;
    });
  }

  sendStory() async {
    DataBase db = DataBase();
    setState(() {
      _uploading = true;
    });
    String storyUrl = await db.uploadStory(_previewFile);
    await db.setStory(storyUrl);
    setState(() {
      _uploading = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      backgroundColor: Colors.black,
      titleSpacing: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          const SizedBox(width: 16),
          CircleAvatar(
            backgroundImage: NetworkImage(
              widget.profileUrl,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2, left: 12),
            child: Text(
              widget.displayName,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: _imageSelected
          ? FloatingActionButton(
              onPressed: sendStory,
              child: _uploading
                  ? const CircularProgressIndicator()
                  : const Icon(Icons.send),
            )
          : const SizedBox(),
      appBar: appBar,
      body: Container(
        margin: EdgeInsets.only(bottom: appBar.preferredSize.height),
        alignment: Alignment.center,
        child: widget.viewStory
            ? Image.network(
                widget.storyfileUrl,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              )
            : _imageSelected
                ? Image.file(_previewFile)
                : GestureDetector(
                    onTap: _selectImage,
                    child: Text(
                      'Add Story',
                      style: TextStyle(
                        fontSize: 28,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
      ),
    );
  }
}
