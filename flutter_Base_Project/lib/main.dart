import 'package:flutter/material.dart';

import 'auth/login_screen.dart';
import 'gatherer-view/requests.dart';
import 'caretaker-view/order.dart';

import 'landowner-view/overview.dart';
import 'landowner-view/landowner_registration.dart';

import 'education/browse_list.dart';

import 'personal/profile.dart';

void main() {
  runApp(
    MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/request-board': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return GathererRoute(user: args['user']);
        },
        '/caretaker': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return CaretakerRoute(user: args['user']);
        },
        '/landowner': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return LandownerRoute(
            user: args['user'],
            uploadSuccess: args['uploadSuccess'] ?? false,
            );
        },
        '/landowner-registration': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return LandownerRegistration(user: args['user']);
        },
        '/education': (context) {
          return BrowseListPage();
        },
        '/profile': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return ProfileRoute(user: args['user']);
        },
      },
    ),
  );
}