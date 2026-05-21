import 'package:flutter/material.dart';
import '../auth/auth.dart';
import '../donate.dart';
import '../Screens/help_faq_screen.dart';

class UserDrawer extends StatefulWidget {
  const UserDrawer({super.key, required this.username, required this.user});

  final User user;
  final String username;

  @override
  State<UserDrawer> createState() => _UserDrawer();
}

class _UserDrawer extends State<UserDrawer> {
  GestureTapCallback drawerButton(String page) {
    return () {
      Navigator.pop(context);

      Navigator.of(context, rootNavigator: true).pushNamed(
        page,
        arguments: {'user': widget.user},
      );
    };
  }

  void signOut() {
    Navigator.pop(context);

    Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
      '/login',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final role = widget.user.claims['custom:role']
        ?.toString()
        .replaceAll('[', '')
        .replaceAll(']', '')
        .trim()
        .toLowerCase();

    return Drawer(
      backgroundColor: const Color.fromRGBO(245, 245, 237, 1),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(46, 165, 107, 1),
            ),
            child: Text(
              'Hi ${widget.username}',
              style: const TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Your Account'),
            onTap: drawerButton('/profile'),
          ),

          if (role == 'landholder')
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Landholder Profile'),
              onTap: drawerButton('/landowner'),
            ),

          ListTile(
            leading: const Icon(Icons.volunteer_activism),
            title: const Text('Support / Donate'),
            onTap: () {
              Navigator.pop(context);
              Donate.openPayPal();
            },
          ),

          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help & FAQ'),
            onTap: () {
              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HelpFAQScreen(),
                ),
              );
            },
          ),

          const Divider(),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Sign Out',
              style: TextStyle(color: Colors.red),
            ),
            onTap: signOut,
          ),
        ],
      ),
    );
  }
}