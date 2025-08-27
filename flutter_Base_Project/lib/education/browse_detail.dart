import 'package:flutter/material.dart';
import '../models/browse.dart';

class BrowseDetailPage extends StatelessWidget {
  final Browse browse;

  const BrowseDetailPage({Key? key, required this.browse}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(browse.commonName)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Latin Name: ${browse.latinName}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Description:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(browse.description),
          ],
        ),
      ),
    );
  }
}