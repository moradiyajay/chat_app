import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DataBase {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future addUserToFirebase(String userID, Map<String, dynamic> userInfo) async {
    await _firebaseFirestore.collection('users').doc(userID).set(userInfo);
  }

  Future<Stream<QuerySnapshot>> getUserByUserName(String username) async {
    return _firebaseFirestore
        .collection("users")
        .where("username", isEqualTo: username)
        .snapshots();
  }

  Future addMessage(String roomId, Map<String, dynamic> messageInfo) async {
    return _firebaseFirestore
        .collection('chatRooms')
        .doc(roomId)
        .collection('chats')
        .add(messageInfo);
  }

  Future updateLastMessgae(
      String roomId, Map<String, dynamic> messageInfo) async {
    return _firebaseFirestore
        .collection('chatRooms')
        .doc(roomId)
        .set(messageInfo);
  }

  Future<DocumentSnapshot> getUserInfo(String uid) async {
    return await _firebaseFirestore.doc('users/$uid').get();
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

  Stream<QuerySnapshot> getAllMessages(String roomId) {
    return _firebaseFirestore
        .collection('chatRooms')
        .doc(roomId)
        .collection('chats')
        .orderBy('ts', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getChatRooms() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    return _firebaseFirestore
        .collection('chatRooms')
        .where("users", arrayContains: uid)
        .orderBy('lastTs', descending: true)
        .snapshots();
  }

  Future<String> uploadFile(File image, String roomId) async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('chat-images')
        // ignore: unnecessary_string_escapes
        .child('$roomId\_${Timestamp.now().seconds.toString()}');

    await ref.putFile(File(image.path)).whenComplete(() => null);
    return ref.getDownloadURL();
  }

  void deleteImage() {}
}
