import 'package:flutter/material.dart';

class UserDrawer extends StatefulWidget {
  const UserDrawer({super.key, required this.username});
  
  final String username;

  @override
  State<UserDrawer> createState() => _UserDrawer();
 }

class _UserDrawer extends State<UserDrawer> {
  
  String selectedDrawerPage = '';

  GestureTapCallback drawerButton(String page) {
    return () {
      setState(() {
        selectedDrawerPage = page;
      });
      Navigator.pop(context);
    };
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: Color.fromRGBO(46, 165, 107, 1)),
            child: Text(
              'Hi ${widget.username}',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          // ListTile(
          //   leading: const Icon(Icons.message),
          //   title: const Text('Messages'),
          //   onTap: drawerButton('Messages'),
          // ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Profile'),
            onTap: drawerButton('Profile'),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: drawerButton('Settings'),
          ),
        ],
      ),
    );
  }
}