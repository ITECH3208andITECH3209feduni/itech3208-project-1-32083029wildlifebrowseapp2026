import 'package:flutter/material.dart';

class LandOwnerRoute extends StatelessWidget {
  final dynamic user;
  const LandOwnerRoute({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tap Me Page"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ), // AppBar
    ); // Scaffold
  }
}
