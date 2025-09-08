import 'package:flutter/material.dart';
import '../auth/auth.dart';

class UserDrawer extends StatefulWidget {
  const UserDrawer({super.key, required this.username, required this.user});
  
  final User user;
  final String username;

  @override
  State<UserDrawer> createState() => _UserDrawer();
 }

class _UserDrawer extends State<UserDrawer> {
  
  // String selectedDrawerPage = '';

  GestureTapCallback drawerButton(String page, User user) {
    return () {
      setState(() {
        Navigator.of(
          context,
          rootNavigator: true,
        ).pushNamed(
          page,
          arguments: {'user': widget.user},
          );
      });
      Navigator.pop(context);
    };
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromRGBO(245, 245, 237, 1),
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
            onTap: drawerButton('/profile', widget.user),
          ),
          // ListTile(
          //   leading: const Icon(Icons.settings),
          //   title: const Text('Settings'),
          //   onTap: drawerButton('/settings', widget.user),
          // ),
        ],
      ),
    );
  }
}