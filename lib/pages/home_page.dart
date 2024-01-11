import 'package:chit_chat/components/my_drawer.dart';
import 'package:chit_chat/components/user_tile.dart';
import 'package:chit_chat/pages/chat_page.dart';
import 'package:chit_chat/services/auth/auth_service.dart';
import 'package:chit_chat/services/chat/chat_service.dart';
import 'package:flutter/material.dart';


class HomePage extends StatelessWidget {
  HomePage({super.key});

  //chat and auth service
  final ChatService _chatService=ChatService();
  final AuthService _authService=AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Home        ")),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      drawer: const MyDrawer(),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList(){
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        //error
        if(snapshot.hasError){
          return const Text("Error");
        }
        //load
        if(snapshot.connectionState==ConnectionState.waiting){
          return const Text("Loading...");
        }
        //return List
        return ListView(
          children: snapshot.data!
            .map<Widget>((userData)=> _buildUserListItem(userData, context))
            .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(Map<String, dynamic> userData,BuildContext context){
    //display other users 
    return UserTile(
      text: userData["email"],
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              receiverEmail: userData["email"],
              receiverID: userData['uid'],
            ),
          ),
        );
      },
    );
  }
}