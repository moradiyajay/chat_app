import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DataBase {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final Reference _firebaseStorageRef = FirebaseStorage.instance.ref();
  final String _uid = FirebaseAuth.instance.currentUser!.uid;

  Future addUserToFirebase(String userID, Map<String, dynamic> userInfo) async {
    await _firebaseFirestore.collection('users').doc(userID).set(userInfo);
  }

  // No need to use
  Future createChatRoom(
      String chatRoomId, Map<String, dynamic> chatRoomInfoMap) async {
    chatRoomId = chatRoomId.trim();
    final snapShot =
        await _firebaseFirestore.collection("chatRooms").doc(chatRoomId).get();

    if (snapShot.exists) {
      // chatroom already exists
      return true;
    } else {
      // chatroom does not exists
      return _firebaseFirestore
          .collection("chatRooms")
          .doc(chatRoomId)
          .update(chatRoomInfoMap);
    }
  }

  Future addMessage(String roomId, Map<String, dynamic> messageInfo) async {
    return _firebaseFirestore
        .collection('chatRooms')
        .doc(roomId)
        .collection('chats')
        .add(messageInfo);
  }

  Future<void> setDeviceId(String id) async {
    return _firebaseFirestore.collection('users').doc(_uid).update({
      'notificationId': id,
    });
  }

  Future<void> updateUserData(Map<String, dynamic> data) async {
    return _firebaseFirestore.collection('users').doc(_uid).update(data);
  }

  Stream<QuerySnapshot> getUsers() {
    return _firebaseFirestore.collection("users").snapshots();
  }

  Stream<QuerySnapshot> getUserByUserName(String username) {
    return _firebaseFirestore
        .collection("users")
        .where("username", isEqualTo: username)
        .snapshots();
  }

  Future updateLastMessgae(
      String roomId, Map<String, dynamic> messageInfo) async {
    return _firebaseFirestore
        .collection('chatRooms')
        .doc(roomId)
        .set(messageInfo);
  }

  Future<DocumentSnapshot> getUserInfo(String? uid, [bool isMe = false]) async {
    return await _firebaseFirestore.doc('users/${isMe ? _uid : uid}').get();
  }

  Stream<QuerySnapshot> getAllMessages(String roomId) {
    return _firebaseFirestore
        .collection('chatRooms')
        .doc(roomId)
        .collection('chats')
        .orderBy('ts', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getChatRooms() {
    return _firebaseFirestore
        .collection('chatRooms')
        .where("users", arrayContains: _uid)
        .orderBy('lastTs', descending: true)
        .snapshots();
  }

  Future<String> uploadFile(File image, String roomId,
      [SettableMetadata? metadata, bool profileImage = false]) async {
    Reference ref = _firebaseStorageRef
        .child(profileImage ? 'profiles' : 'chat-images')
        // ignore: unnecessary_string_escapes
        .child('$roomId\_${Timestamp.now().seconds.toString()}');

    await ref.putFile(File(image.path), metadata).whenComplete(() => null);
    return ref.getDownloadURL();
  }

  Future<Map<String, String>?> getMetaData(String location) async {
    var data = await _firebaseStorageRef.child(location).getMetadata();
    Map<String, String>? customData = data.customMetadata;
    return customData;
  }

  Future<String> uploadStory(File image, [SettableMetadata? metadata]) async {
    Reference ref = _firebaseStorageRef
        .child('user-stories')
        // ignore: unnecessary_string_escapes
        .child('$_uid\_${Timestamp.now().seconds.toString()}');

    await ref.putFile(File(image.path), metadata).whenComplete(() => null);
    return ref.getDownloadURL();
  }

  Future<void> setStory(String storyUrl) async {
    return _firebaseFirestore.collection('users').doc(_uid).update({
      'story': storyUrl,
    });
  }
}
