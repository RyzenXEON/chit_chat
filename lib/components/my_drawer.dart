import 'package:chit_chat/services/auth/auth_service.dart';
import 'package:chit_chat/pages/settings_page.dart';
import 'package:flutter/material.dart';

  class MyDrawer extends StatelessWidget {

    void logout(){
    //calling auth service
      final auth = AuthService();
      auth.signOut();
  }

    const MyDrawer({super.key});

    @override
    Widget build(BuildContext context) {
      return Drawer(
        backgroundColor: Theme.of(context).colorScheme.background,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                //logo
                DrawerHeader(
                  child: Center(
                    child: Icon(
                      Icons.message,
                      color: Theme.of(context).colorScheme.primary,
                      size: 40,
                    ),
                  ),
                ),

                //home tile
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTile(
                    title: const Text("H O M E"),
                    leading: const Icon(Icons.home),
                    onTap: () {
                      //pop drawer
                      Navigator.pop(context);
                    },
                  ),
                ),

                //setting tile
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTile(
                    title: const Text("S E T T I N G S"),
                    leading: const Icon(Icons.settings),
                    onTap: () {
                      //pop drawer
                      Navigator.pop(context);
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context)=>const SettingsPage(),
                        )
                      );
                    },
                  ),
                ),
              ],
            ),

            //logout tile
             Padding(
              padding: const EdgeInsets.only(left: 25.0,bottom: 25),
              child: ListTile(
                title: const Text("L O G O U T"),
                leading:const Icon(Icons.logout),
                onTap: logout,
              ),
            ),
          ],
        ),
      );
    }
  }