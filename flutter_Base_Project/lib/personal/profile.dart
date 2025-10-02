import 'package:flutter/material.dart';

import '../templates/drawer.dart';
import '../auth/auth.dart';
import '../auth/config.dart';
import '../auth/user_service.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:change_case/change_case.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class ProfileRoute extends StatelessWidget {

  final User user;
  const ProfileRoute({super.key, required this.user});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '${user.claims['given_name']}\'s profile',
      theme: ThemeData(
        listTileTheme: const ListTileThemeData(textColor: Colors.black),
        scaffoldBackgroundColor: const Color.fromRGBO(245, 245, 237, 1),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(46, 165, 107, 1)),
        useMaterial3: true,
      ),
      // Set username of Gatherer here
      home: Profile(title: '${user.claims['given_name']}\'s profile', user: user),
    );
  }
}

class Profile extends StatefulWidget {
  const Profile({
    super.key,
    required this.title,
    required this.user,
  });

  final String title;
  final User user;

  @override
  State<Profile> createState() => _Profile();
}

class _Profile extends State<Profile> {

  @override
  void initState() {
    super.initState();
  }

  void showEditDialogTwo(String key1, String key2, String editDialog) {
    TextEditingController firstController = TextEditingController(
      text: key1 == 'address' 
    ? widget.user.claims[key1]['formatted']
    : widget.user.claims[key1].toString(),
    );

    TextEditingController secondController = TextEditingController(text: widget.user.claims[key2].toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $editDialog'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: firstController,
              decoration: InputDecoration(labelText: key1.split('_').join(' ').toCapitalCase()),
            ),
            TextField(
              controller: secondController,
              decoration: InputDecoration(labelText: key2.split('_').join(' ').toCapitalCase()),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              setState(() {
                widget.user.claims[key1] = firstController.text;
                widget.user.claims[key2] = secondController.text;
              });
              
              if (mounted) {
                Navigator.pop(context);
              }
              
             updateUserAttributes({
              key1: firstController.text,
              key2: secondController.text
             });
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }


  void showEditDialogOne(String key) {
    TextEditingController firstController = TextEditingController(text: widget.user.claims[key].toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${key.split('_').join(' ').toCapitalCase()}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: firstController,
              decoration: InputDecoration(labelText: key.split('_').join(' ').toCapitalCase()),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              setState(() {
                widget.user.claims[key] = firstController.text;
              });
              
              if (mounted) {
                Navigator.pop(context);
              }
              
             updateUserAttributes(
              {key: firstController.text}
             );
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  // Profile initial state
  Widget build(BuildContext context) {
    final String appTitle = '${widget.user.claims['given_name']}\'s profile';
    final String username = widget.user.claims['given_name'];

    return MaterialApp(
      theme: ThemeData(
        listTileTheme: const ListTileThemeData(textColor: Colors.black),
        scaffoldBackgroundColor: const Color.fromRGBO(245, 245, 237, 1),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(46, 165, 107, 1)),
        useMaterial3: true,
      ),
      title: appTitle,
      // SafeArea ensures that the view isn't obstructed by phone notch/status bar/bezel
      home: SafeArea(
        minimum: const EdgeInsets.all(12.0),
        child: Scaffold(
          backgroundColor: const Color.fromRGBO(245, 245, 237, 1),
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(appTitle),
            actions: [
               // Icon to move to gatherer request board page
              IconButton(
                icon: const Icon(Icons.pageview_outlined),
                tooltip: 'View the request board',
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pushNamed(
                    '/request-board',
                    arguments: {'user': widget.user},
                    );
                },
              ),
               // Icon to move to caretaker order request page
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                tooltip: 'Make a order request',
                onPressed: () {
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).pushNamed(
                    '/caretaker', 
                    arguments: {'user': widget.user},
                    );
                },
              ),
               // Icon to move to browse info page
              IconButton(
                icon: const Icon(Icons.search),
                tooltip: 'Explore browse',
                onPressed: () {
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).pushNamed(
                    '/education'
                    );
                },
              ),
            ],
          ),
          drawer: UserDrawer(username: username, user:widget.user),
          // Profile body
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text('Name: $username ${widget.user.claims['family_name']}'),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      showEditDialogTwo('given_name', 'family_name', 'Name');
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text('Birthdate: ${widget.user.claims['birthdate']}'),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      showEditDialogOne('birthdate');
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text('Image: ${widget.user.claims['picture']}'),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      showEditDialogOne('picture');
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text('Email: ${widget.user.claims['email']}'),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      showEditDialogOne('email');
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text('Email verified? ${widget.user.claims['email_verified']}'),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      showEditDialogOne('email_verified');
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.place, size: 14),
                  Text(
                    "Your address: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Text('${widget.user.claims['address']['formatted']}, ${widget.user.claims['custom:postcode']}'),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      showEditDialogTwo('address', 'custom:postcode', 'Address');
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text('Role: ${widget.user.claims['custom:role']}'),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      showEditDialogOne('custom:role');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget phoneNumber(phone) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.phone_android_outlined, size: 14),
          Text(
            "Phone: ",
            style: TextStyle(fontWeight: FontWeight.bold),
            ),
          Text("$phone"),
        ], 
  );
}

Widget visitingTimes(visit) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.time_to_leave, size: 14),
          Text(
            "My visiting times: ",
            style: TextStyle(fontWeight: FontWeight.bold),
            ),
          Text("$visit"),
        ], 
  );
}

Widget advanceWarning(advance) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notification_add, size: 14),
          Text(
            "Advance warning needed? ",
            style: TextStyle(fontWeight: FontWeight.bold),
            ),
          Text("$advance"),
        ], 
  );
}

Future<void> updateUserAttributes(Map<String, String> attributes) async {
  final config = await loadConfig();
  final authService = UserPoolAuthService(config.userPoolID, config.clientID);
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? password = prefs.getString('password');

  final success = await authService.updateUserAttributes(
    attributes, password!
  );

  if (success) {
    print("Attributes updated successfully");
  } else {
    print("Attributes weren't updated");
  }
}