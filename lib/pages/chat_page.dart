

import 'package:chit_chat/components/chat_bubble.dart';
import 'package:chit_chat/components/chat_textfield.dart';
import 'package:chit_chat/services/auth/auth_service.dart';
import 'package:chit_chat/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

  const ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  //text controller
  final TextEditingController _messageController = TextEditingController();
  //auth and chat service
  final ChatService _chatService=ChatService();
  final AuthService _authService=AuthService();
  bool _isSending = false;

  //scroll to latest text
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    //focus node listener
    myFocusNode.addListener(() {
      if(myFocusNode.hasFocus){
        Future.delayed(
          const Duration(milliseconds: 500),
          ()=> scrollDown(),
        );
      }
    });

    //wait for msg to load up
    Future.delayed(
      const Duration(milliseconds: 500),
      ()=> scrollDown(),
    );
    
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  //scroll controller
  final ScrollController _scrollController=ScrollController();
  void scrollDown(){
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }


  //send msg
  void sendMessage() async{
    //send only if text is there
    if(_messageController.text.isNotEmpty && !_isSending){
      _isSending =true;
      await _chatService.sendMessage(widget.receiverID, _messageController.text);
      _messageController.clear();
      _isSending = false;
    }
    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverEmail),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: Column(
        children: [
          //display msg
          Expanded(
            child: _buildMessageList(),
          ),

          //message box
          _buildUserInput(),

        ],
      ),
    );  
  }

  //build msg list
  Widget _buildMessageList(){
    String senderID=_authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverID, senderID),
      builder: (context, snapshot) {
        //errors
        if(snapshot.hasError){
          return const Text("Error");
        }

        //loading
        if(snapshot.connectionState== ConnectionState.waiting){
          return const Text("Loading...");
        }

        //return list view
        return ListView(
          controller: _scrollController,
          children: snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      }
    );
  }

  //build msg item
  Widget _buildMessageItem(DocumentSnapshot doc){
    Map<String, dynamic> data=doc.data() as Map<String, dynamic>;

    //current user?
    bool isCurrentUser= data['senderID']==_authService.getCurrentUser()!.uid;

    //align right if current user
    var alignment =isCurrentUser?Alignment.centerRight : Alignment.centerLeft;


    return Container(
      alignment: alignment,
      child: Column(
        children: [
          ChatBubble(
            message: data["message"],
            isCurrentUser: isCurrentUser,
          ),
        ],
      ),
    );
  }

  //build msg input
  Widget _buildUserInput(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        children: [
          //textfield for msg
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: "Type message",
              obscureText: false,
              focusNode: myFocusNode,

            ),
          ),
      
          //send button
          Container(
            decoration: const BoxDecoration(
              color: Colors.purple,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(right: 25),
            child: IconButton(
              onPressed: _isSending ? null : sendMessage,
              icon: const Icon(Icons.arrow_upward, color: Colors.white,),
            ),
          )
        ],
      ),
    );
  }
}