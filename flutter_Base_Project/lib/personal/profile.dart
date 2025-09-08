import 'package:flutter/material.dart';

import '../templates/drawer.dart';
import '../templates/browseList.dart';
import '../jsonParser.dart';
import '../auth/auth.dart';

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

class _Profile extends State<Profile>
    with TickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;


  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    // Start animations
    _fadeController.forward();
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
              personalAddress(widget.user.claims['address']['formatted']),
            ],
          ),
        ),
      ),
    );
  }
}

Widget personalAddress(address) {
  return Align(
    alignment: Alignment.centerLeft,
    child: RichText(
      text: TextSpan(
        children: [
          WidgetSpan(child: Icon(Icons.place, size: 14)),
          TextSpan(text: "Address\n$address")
        ],
      ),
    ),
  );
}

bool _showPhone = true;

Widget phoneNumber(phone) {
  return Align(
    alignment: Alignment.centerLeft,
    child: RichText(
      text: TextSpan(
        children: [
          WidgetSpan(child: Icon(Icons.phone_android_outlined, size: 14)),
          _showPhone
              ? TextSpan(text: "Phone\n$phone")
              : TextSpan(text: "Phone\n "),
        ],
      ),
    ),
  );
}

Widget visitingTimes(visit) {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          children: [
            WidgetSpan(child: Icon(Icons.time_to_leave, size: 14)),
            TextSpan(text: "Visiting Times"),
            TextSpan(text: visit),
            TextSpan(text: visit),
          ],
        ),
      ),
    );
  }

  Widget advanceWarning(advance) {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          children: [
            WidgetSpan(child: Icon(Icons.notification_add, size: 14)),
            TextSpan(text: "Advance Warning"),
            TextSpan(text: advance),
          ],
        ),
      ),
    );
  }