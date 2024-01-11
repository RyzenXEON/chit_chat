import 'package:chit_chat/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService{

  //firestore and auth
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  final FirebaseAuth _auth=FirebaseAuth.instance;

  //user stream
  Stream<List<Map<String,dynamic>>> getUsersStream(){
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc){
        //go through each individual user
        final user =doc.data();

        //return user
        return user;
      }).toList();
    });
  }

  //send msg
  Future<void> sendMessage(String receiverID, message) async{
    //get current user info
    final String currentUserID= _auth.currentUser!.uid;
    final String currentUserEmail= _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    //new msg
    Message newMessage = Message(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      receiverID: receiverID,
      message: message,
      timestamp: timestamp,
    );

    //chat room unique id
    List<String> ids =[currentUserID, receiverID];
    ids.sort();
    String chatRoomID =ids.join('_');

    //add msg to database
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());
  }

  //get msg
  Stream<QuerySnapshot> getMessages(String userID, otherUserID){
    //chat room  id
    List<String> ids =[userID, otherUserID];
    ids.sort();
    String chatRoomID =ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

}