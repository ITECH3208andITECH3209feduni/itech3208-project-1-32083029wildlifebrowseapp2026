import 'package:flutter/material.dart';

import 'auth/login_screen.dart';
import 'gatherer-view/requests.dart';
import 'caretaker-view/order.dart';
import 'landowner-view/overview.dart';


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
        '/detailed-request': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return DetailedRequest(title: args['Request Details'], request: args['request'], item: args['item'], animal: args['animal']);
        },
        '/caretaker': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return CaretakerRoute(user: args['user']);
        },
        '/landowner': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return LandOwnerRoute(user: args['user']);
        },
      },
    ),
  );
}