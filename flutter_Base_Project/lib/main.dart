import 'package:flutter/material.dart';

import 'gatherer-view/requests.dart';
import 'caretaker-view/order.dart';
import 'landowner-view/overview.dart';

void main() {
  runApp(
    MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const GathererRoute(),
        '/detailed-request': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return DetailedRequest(title: args['Request Details'], request: args['request'], item: args['item'], animal: args['animal']);
        },
        '/caretaker': (context) => const CaretakerRoute(),
        '/landowner': (context) => const LandOwnerRoute(),
      },
    ),
  );
}