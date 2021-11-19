import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../components/media_icon.dart';
import '../helpers/database_service.dart';
import '../provider/firebase_service.dart';
import '../widgets/rectangle_button.dart';
import '../widgets/rectangle_input_field.dart';

enum Settings { Home, Accounts, Notifications, Report, Help }

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  Settings _settings = Settings.Home;
  final FirebaseServiceProvider _firebaseServiceProvider =
      FirebaseServiceProvider();
  bool loading = false;
  late User _user;
  final _formKey = GlobalKey<FormState>();
  bool _showNotifications = true;
  String _username = '';
  String _displayName = '';
  String _profileUrl = '';
  late File? _previewFile;
  bool _previewImageInitialize = false;
  final DataBase _db = DataBase();

  String enumToString(Settings settings) {
    switch (settings) {
      case Settings.Accounts:
        return "Accounts Settings";
      case Settings.Notifications:
        return "Notifications";
      case Settings.Report:
        return "Report a Problem";
      case Settings.Help:
        return "Help & Support";
      default:
        return "Settings";
    }
  }

  @override
  void initState() {
    super.initState();
    _user = _firebaseServiceProvider.user!;
    () async {
      DocumentSnapshot docs = await _db.getUserInfo(null, true);
      Map docMap = docs.data() as Map<String, dynamic>;
      _showNotifications = docMap["showNotifications"] ?? true;
      _username = docMap["username"];
      _displayName = docMap["displayName"] ?? _user.displayName;
      _profileUrl = docMap["profileURl"] ?? _user.photoURL;

      setState(() {});
    }();
  }

  List<Widget> currentSettings() {
    var homeSettings = [
      SettingsOption(
          onTap: () {
            setState(() {
              _settings = Settings.Accounts;
            });
          },
          text: 'Account Settings'),
      SettingsOption(
          onTap: () {
            setState(() {
              _settings = Settings.Notifications;
            });
          },
          text: 'Notifications'),
      SettingsOption(
          onTap: () {
            setState(() {
              _settings = Settings.Report;
            });
          },
          text: 'Report a Problem'),
      SettingsOption(
          onTap: () {
            setState(() {
              _settings = Settings.Help;
            });
          },
          text: 'Help & Support'),
    ];
    var accountSettings = [
      Form(
        key: _formKey,
        child: Column(
          children: [
            RectangleInputField(
              hintText: _username,
              primaryColor:
                  Theme.of(context).colorScheme.secondary.withOpacity(0.05),
              secondaryColor: Theme.of(context).colorScheme.secondary,
              icon: CupertinoIcons.person_fill,
              onSaved: (String value) {
                if (value.isNotEmpty) {
                  _username = value.toLowerCase();
                }
              },
            ),
            RectangleInputField(
              hintText: _displayName,
              primaryColor:
                  Theme.of(context).colorScheme.secondary.withOpacity(0.07),
              secondaryColor: Theme.of(context).colorScheme.secondary,
              icon: CupertinoIcons.person,
              onSaved: (String value) {
                if (value.isNotEmpty) {
                  _displayName = value;
                }
              },
            ),
          ],
        ),
      )
    ];

    var notificationSettings = [
      Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Show Notifications',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            Switch.adaptive(
                value: _showNotifications,
                onChanged: (value) {
                  setState(() {
                    _showNotifications = !_showNotifications;
                  });
                }),
          ],
        ),
      ),
    ];

    var reportSettings = [
      const SizedBox(height: 10),
      const Text('Visit:'),
      Text(
        'https://github.com/juniorbomb/chat_app/issues',
        style: TextStyle(
          decoration: TextDecoration.underline,
          color: Colors.blue.shade600,
        ),
      ),
    ];

    var helpSettings = [
      const SizedBox(height: 10),
      const Text('Visit:'),
      Text(
        'https://github.com/juniorbomb/chat_app',
        style: TextStyle(
          decoration: TextDecoration.underline,
          color: Colors.blue.shade600,
        ),
      ),
    ];

    switch (_settings) {
      case Settings.Accounts:
        return accountSettings;
      case Settings.Notifications:
        return notificationSettings;
      case Settings.Report:
        return reportSettings;
      case Settings.Help:
        return helpSettings;
      default:
        return homeSettings;
    }
  }

  onClick() {}

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
                text: 'Take Photo',
                onClick: () {
                  imageSource = ImageSource.camera;
                  Navigator.pop(context);
                },
                icon: CupertinoIcons.camera_fill,
              ),
              const SizedBox(width: 20),
              MediaIcon(
                backgroundColor: Colors.pinkAccent,
                text: 'Choose from Gallery',
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
      _previewImageInitialize = true;
    });
  }

  profileImageProvider() {
    return _previewImageInitialize
        ? FileImage(_previewFile!)
        : NetworkImage(_profileUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              height: 35,
              child: _settings == Settings.Home
                  ? null
                  : IconButton(
                      onPressed: () {
                        setState(() {
                          _settings = Settings.Home;
                        });
                      },
                      icon: const Icon(Icons.arrow_back))),
          Center(
            child: GestureDetector(
              onTap: _settings == Settings.Accounts ? _imagePicker : null,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Stack(
                  children: [
                    CircleAvatar(
                      backgroundImage: profileImageProvider(),
                      radius: 30,
                    ),
                    if (_settings == Settings.Accounts)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          color: Colors.black38,
                          child: const Icon(
                            CupertinoIcons.camera_fill,
                            size: 15,
                            color: Colors.white38,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              _user.displayName!,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
              child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            margin: const EdgeInsets.only(top: 24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(40),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  enumToString(_settings),
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...currentSettings(),
                const Spacer(),
                if (_settings != Settings.Help && _settings != Settings.Report)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: loading
                        ? const Center(child: CircularProgressIndicator())
                        : RectangleButton(
                            text:
                                _settings == Settings.Home ? 'Log Out' : 'Save',
                            callback: save,
                            backgroundColor: _settings == Settings.Home
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).colorScheme.secondary,
                          ),
                  ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  void save() async {
    setState(() {
      loading = true;
    });
    if (_settings == Settings.Home) {
      FirebaseServiceProvider().logOut();
    } else if (_settings == Settings.Accounts) {
      _formKey.currentState!.save();
      await _user.updateDisplayName(_displayName);
      if (_previewImageInitialize) {
        String imageUrl =
            await _db.uploadFile(_previewFile!, _user.uid, null, true);
        setState(() {
          _profileUrl = imageUrl;
        });
        _user.updatePhotoURL(_profileUrl);
      }
      await _db.updateUserData({
        'username': _username,
        "displayName": _displayName,
        "profileURL": _profileUrl,
      });
    } else if (_settings == Settings.Notifications) {
      await _db.updateUserData({
        'showNotifications': _showNotifications,
      });
    }
    setState(() {
      loading = false;
      _previewImageInitialize = false;
    });
  }
}

class SettingsOption extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  const SettingsOption({
    required this.onTap,
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Icon(
              CupertinoIcons.forward,
              color: Colors.black54,
            )
          ],
        ),
      ),
    );
  }
}
