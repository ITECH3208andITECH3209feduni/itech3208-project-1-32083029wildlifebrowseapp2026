import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth/login_screen.dart';
import 'gatherer-view/requests.dart';
import 'caretaker-view/order.dart';

import 'landowner-view/overview.dart';
import 'landowner-view/landowner_registration.dart';
import 'landowner-view/landholder_tutorial.dart';

import 'education/browse_list.dart';

import 'personal/profile.dart';
import 'auth/agreement_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final hasAgreed = prefs.getBool('user_agreed') ?? false;

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: hasAgreed ? '/login' : '/agreement',
      routes: {
        '/agreement': (context) => const AgreementScreen(),
        '/login': (context) => const LoginScreen(),

        '/request-board': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

          return GathererRoute(user: args['user']);
        },

        '/caretaker': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

          return CaretakerRoute(user: args['user']);
        },

        '/landowner': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

          return LandownerRoute(
            user: args['user'],
            browseFilter: args['browseFilter'] ?? <String>[],
            uploadSuccess: args['uploadSuccess'] ?? false,
          );
        },

        '/landholder-tutorial': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

          return LandholderTutorial(user: args['user']);
        },

        '/landowner-registration': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

          return LandownerRegistration(user: args['user']);
        },

        '/education': (context) {
          return BrowseListPage();
        },

        '/profile': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

          return ProfileRoute(user: args['user']);
        },
      },
    ),
  );
}