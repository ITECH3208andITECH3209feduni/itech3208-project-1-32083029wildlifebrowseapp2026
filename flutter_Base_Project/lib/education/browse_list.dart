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
    Browse(
      id: '1',
      commonName: 'Southern blue gum, Blue gum',
      latinName: 'Eucalyptus globulus',
      topImageUrl: 'assets/images/manna_gum_m_morey_01_copyright.png',
      description: 'A species of flowering plant in the family Myrtaceae. It is a tall, evergreen tree, with four subspecies, all endemic to southeastern Australia',
      leafShape: 'Lanceolate (Long narrow leaf shape pointed like a lance)',
      leafImageUrl: 'assets/images/manna_gum_m_morey_02_copyright.png',
      plantShape: 'Tall tree with a dense canopy',
      plantImageUrl: 'assets/images/manna_gum_m_morey_03_copyright.png',
      barkTexture: 'Usually smooth and white to cream-coloured',
      barkImageUrl: 'assets/images/manna_gum_m_morey_04_copyright.png',
      flowers: 'Ribbed flower buds arranged singly or in groups of three or seven with white-coloured flowers',
      flowersImageUrl: 'assets/images/manna_gum_m_morey_05_copyright.png',
    ),
    Browse(
      id: '2',
      commonName: 'Manna gum, White gum, Ribbon gum',
      latinName: 'Eucalyptus viminalis',
      topImageUrl: 'assets/images/manna_gum_m_morey_01_copyright.png',
      description: 'Ranges in height from small to very tall, typically about 50m in height but can reach 90m. Endemic to southeastern Australia',
      leafShape: 'Lanceolate (Long narrow leaf shape pointed like a lance) with a slight curve',
      leafImageUrl: 'assets/images/manna_gum_m_morey_02_copyright.png',
      plantShape: 'Adult leaves are arranged alternately',
      plantImageUrl: 'assets/images/manna_gum_m_morey_03_copyright.png',
      barkTexture: 'Has smooth, often powdery, white to pale brown bark that it sheds in long ribbons',
      barkImageUrl: 'assets/images/manna_gum_m_morey_04_copyright.png',
      flowers: 'Ribbed flower buds arranged singly or in groups of three or seven with white-coloured flowers. Fruit are woody and cup-shaped',
      flowersImageUrl: 'assets/images/manna_gum_m_morey_05_copyright.png',
    ),
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
        title: Text("Browse catalog"),
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