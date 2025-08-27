import 'package:flutter/material.dart';
import '../models/browse.dart';
import 'browse_detail.dart';

class BrowseListPage extends StatefulWidget {
  @override
  _BrowseListPageState createState() => _BrowseListPageState();
}

class _BrowseListPageState extends State<BrowseListPage>
//i just put random names for it
 {
  final List<Browse> allBrowses = [
    Browse(commonName: "Rose", latinName: "Rosa", description: "A flowering browse."),
    Browse(commonName: "Sunflower", latinName: "Helianthus", description: "Tall and bright."),
    Browse(commonName: "Lavender", latinName: "Lavandula", description: "Used in aromatherapy."),
  ];

  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final filteredBrowses = allBrowses.where((browse) {
      final query = searchQuery.toLowerCase();
      return browse.commonName.toLowerCase().contains(query) ||
             browse.latinName.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Browse Browses"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search by Common or Latin Name',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredBrowses.length,
              itemBuilder: (context, index) {
                final browse = filteredBrowses[index];
                return ListTile(
                  title: Text(browse.commonName),
                  subtitle: Text(browse.latinName),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BrowseDetailPage(browse: browse),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}