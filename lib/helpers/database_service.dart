import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  Future<QuerySnapshot> getUserInfo(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: username)
        .get();
  }

  // No need to use
  Future createChatRoom(
      String chatRoomId, Map<String, dynamic> chatRoomInfoMap) async {
    final snapShot = await FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatRoomId)
        .get();

    if (snapShot.exists) {
      // chatroom already exists
      return true;
    } else {
      // chatroom does not exists
      return FirebaseFirestore.instance
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

  Future<Stream<QuerySnapshot>> getChatRooms() async {
    String myUsername =
        FirebaseAuth.instance.currentUser!.email!.replaceAll('@gmail.com', '');
    return _firebaseFirestore
        .collection('chatRooms')
        .where("users", arrayContains: myUsername)
        .orderBy('lastTs', descending: true)
        .snapshots();
  }
}