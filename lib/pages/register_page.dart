import 'package:chit_chat/services/auth/auth_service.dart';
import 'package:chit_chat/components/my_button.dart';
import 'package:chit_chat/components/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RegisterPage extends StatelessWidget {

  final TextEditingController _emailController =TextEditingController();
  final TextEditingController _pwController =TextEditingController();
  final TextEditingController _confirmpwController =TextEditingController();

  //tap to go to register page
  final void Function()? onTap;
  RegisterPage({
    super.key,
    required this.onTap,
    });

  //register
  void register(BuildContext context){
    //call auth service
    final _auth =AuthService();

    //check if password == confirm password
    if(_pwController.text==_confirmpwController.text){
      try{
        _auth.signUpWithEmailPassword(
        _emailController.text,
        _confirmpwController.text
      );
      } catch (e){
        showDialog(
        context: context,
         builder: (context)=> AlertDialog(
          title: Text(e.toString()),
         ),
        );
      }
    }
    //if password dont match >> show error
    else{
      showDialog(
        context: context,
         builder: (context)=> AlertDialog(
          title: Text("Passwords don't match!"),
         ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //logo
          Icon(
            Icons.message,
            size: 60,
            color: Theme.of(context).colorScheme.primary,
          ),

          const SizedBox(height: 25,),

          //Welcome
          Text(
            "Create Your Own Chit-Chat",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 25,),

          //email textfield
          MyTextField(
            hintText: "Email",
            obscureText: false,
            controller: _emailController,
          ),

          const SizedBox(height: 10,),

          //password textfield
          MyTextField(
            hintText: "Password",
            obscureText: true,
            controller: _pwController,
          ),

          const SizedBox(height: 10,),

          //confirm password textfield
          MyTextField(
            hintText: "Confirm Password",
            obscureText: true,
            controller: _confirmpwController,
          ),

          const SizedBox(height: 25,),

          //login button
          MyButton(
            buttonName: "Sign Up",
            onTap: ()=>register(context),
          ),
          const SizedBox(height: 25,),

          //SignUp
           Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Have a Chit-Chat account? ",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              GestureDetector(
                onTap: onTap,
                child: Text(
                  "Login Now",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}