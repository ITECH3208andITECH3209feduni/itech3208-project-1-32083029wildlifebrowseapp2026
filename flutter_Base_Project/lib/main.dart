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
        '/detailed-request': (context) => const DetailedRequest(title: 'Request Details'),
        '/caretaker': (context) => const CaretakerRoute(),
        '/landowner': (context) => const LandOwnerRoute(),
      },
    ),
  );
}