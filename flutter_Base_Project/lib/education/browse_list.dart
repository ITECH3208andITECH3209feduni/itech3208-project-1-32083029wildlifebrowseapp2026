import 'package:flutter/material.dart';
import '../models/browseInformation.dart';
import 'browse_detail.dart';

class BrowseListPage extends StatefulWidget {
  @override
  _BrowseListPageState createState() => _BrowseListPageState();
}

class _BrowseListPageState extends State<BrowseListPage>

 {
  final List<Browse> allBrowses = [
    Browse(
      id: '1',
      commonName: 'Southern blue gum, Blue gum',
      latinName: 'Eucalyptus globulus',
      topImageUrl: 'assets/images/manna_gum_m_morey_01_copyright.jpg',
      description: 'A species of flowering plant in the family Myrtaceae. It is a tall, evergreen tree, with four subspecies, all endemic to southeastern Australia',
      leafShape: 'Lanceolate (Long narrow leaf shape pointed like a lance)',
      leafImageUrl: 'assets/images/manna_gum_m_morey_02_copyright.jpg',
      plantShape: 'Tall tree with a dense canopy',
      plantImageUrl: 'assets/images/manna_gum_m_morey_03_copyright.jpg',
      barkTexture: 'Usually smooth and white to cream-coloured',
      barkImageUrl: 'assets/images/manna_gum_m_morey_04_copyright.jpg',
      flowers: 'Ribbed flower buds arranged singly or in groups of three or seven with white-coloured flowers',
      flowersImageUrl: 'assets/images/manna_gum_m_morey_05_copyright.jpg',
      harvestingVideos: ['assets/videos/BWRAC_Eucalypt_Browse.mp4'],
    ),
    Browse(
      id: '2',
      commonName: 'Manna gum, White gum, Ribbon gum',
      latinName: 'Eucalyptus viminalis',
      topImageUrl: 'assets/images/blueGumNut.jpg',
      description: 'Ranges in height from small to very tall, typically about 50m in height but can reach 90m. Endemic to southeastern Australia',
      leafShape: 'Lanceolate (Long narrow leaf shape pointed like a lance) with a slight curve',
      leafImageUrl: 'assets/images/blueGumLeaf.jpg',
      plantShape: 'Adult leaves are arranged alternately',
      plantImageUrl: 'assets/images/blueGumTree.jpg',
      barkTexture: 'Has smooth, often powdery, white to pale brown bark that it sheds in long ribbons',
      barkImageUrl: 'assets/images/blueGumBark.jpg',
      flowers: 'Ribbed flower buds arranged singly or in groups of three or seven with white-coloured flowers. Fruit are woody and cup-shaped',
      flowersImageUrl: 'assets/images/blueGumFlower.jpg',
      harvestingVideos: ['assets/videos/BWRAC_Eucalypt_Browse.mp4'],
    ),
    Browse(
      id: '3',
      commonName: 'Banksia',
      latinName: 'Banksia',
      topImageUrl: 'assets/images/Banksia_04_M_Morey_flower_COPYRIGHT.jpg',
      description: 'description',
      leafShape: 'description',
      leafImageUrl: 'assets/images/Banksia_09_M_Morey_leaf_COPYRIGHT.jpg',
      plantShape: 'description',
      plantImageUrl: 'assets/images/Banksia_08_M_Morey_tree.jpg',
      barkTexture: 'description',
      barkImageUrl: 'assets/images/Banksia_06_M_Morey_bark_COPYRIGHT.jpg',
      flowers: 'descriptiond',
      flowersImageUrl: 'assets/images/Banksia_04_M_Morey_flower_COPYRIGHT.jpg',
      harvestingVideos: ['assets/videos/BWRAC_Eucalypt_Browse.mp4'],
    ),
      Browse(
      id: '4',
      commonName: 'Callistemon',
      latinName: 'Callistemon',
      topImageUrl: 'assets/images/Callistemon_flower.jpg',
      description: 'description',
      leafShape: 'description',
      leafImageUrl: 'assets/images/Callistemon_leaf.jpg',
      plantShape: 'description',
      plantImageUrl: 'assets/images/Callistemon_tree.jpg',
      barkTexture: 'description',
      barkImageUrl: 'assets/images/Callistemon_nuts.jpg',
      flowers: 'descriptiond',
      flowersImageUrl: 'assets/images/Callistemon_flower.jpg',
      harvestingVideos: ['assets/videos/BWRAC_Eucalypt_Browse.mp4'],
    ),
      Browse(
      id: '5',
      commonName: 'Camellia',
      latinName: 'Camellia',
      topImageUrl: 'assets/images/Camellia_M_Morey_flower_COPYRIGHT.jpg',
      description: 'description',
      leafShape: 'description',
      leafImageUrl: 'assets/images/Camellia_M_Morey_leaf_COPYRIGHT.jpg',
      plantShape: 'description',
      plantImageUrl: 'assets/images/Camellia_M_Morey_tree.jpg',
      barkTexture: 'description',
      barkImageUrl: 'assets/images/Camellia_M_Morey_nut.jpg',
      flowers: 'descriptiond',
      flowersImageUrl: 'assets/images/Camellia_M_Morey_flower_COPYRIGHT.jpg',
      harvestingVideos: ['assets/videos/BWRAC_Eucalypt_Browse.mp4'],
    ),
      Browse(
      id: '6',
      commonName: 'Correa',
      latinName: 'Correa',
      topImageUrl: 'assets/images/Correa_M_Morey_flower_COPYRIGHT.jpg',
      description: 'description',
      leafShape: 'description',
      leafImageUrl: 'assets/images/Correa_M_Morey_leaf_COPYRIGHT.jpg',
      plantShape: 'description',
      plantImageUrl: 'assets/images/Correa_M_Morey_tree.jpg',
      barkTexture: 'description',
      barkImageUrl: 'assets/images/Correa_M_Morey_tree.jpg',
      flowers: 'descriptiond',
      flowersImageUrl: 'assets/images/Correa_M_Morey_flower_COPYRIGHT.jpg',
      harvestingVideos: ['assets/videos/BWRAC_Eucalypt_Browse.mp4'],
    ),
      Browse(
      id: '7',
      commonName: 'Grevillea',
      latinName: 'Grevillea',
      topImageUrl: 'assets/images/Grevillea_M_Morey_flower_COPYRIGHT.jpg',
      description: 'description',
      leafShape: 'description',
      leafImageUrl: 'assets/images/Grevillea_M_Morey_tree.jpg',
      plantShape: 'description',
      plantImageUrl: 'assets/images/Grevillea_M_Morey_tree.jpg',
      barkTexture: 'description',
      barkImageUrl: 'assets/images/Grevillea_M_Morey_tree.jpg',
      flowers: 'description',
      flowersImageUrl: 'assets/images/Grevillea_M_Morey_flower_COPYRIGHT.jpg',
      harvestingVideos: ['assets/videos/BWRAC_Eucalypt_Browse.mp4'],
    ),
      Browse(
      id: '8',
      commonName: 'Lilly Pilly',
      latinName: 'Lilly Pilly',
      topImageUrl: 'assets/images/Lilly_Pilly_M_Morey_leaf_COPYRIGHT.jpg',
      description: 'description',
      leafShape: 'description',
      leafImageUrl: 'assets/images/Lilly_Pilly_M_Morey_leaf_COPYRIGHT.jpg',
      plantShape: 'description',
      plantImageUrl: 'assets/images/Lilly_Pilly_M_Morey_tree.jpg',
      barkTexture: 'description',
      barkImageUrl: 'assets/images/Lilly_Pilly_M_Morey_tree.jpg',
      flowers: 'descriptiond',
      flowersImageUrl: 'assets/images/Lilly_Pilly_M_Morey_leaf_COPYRIGHT.jpg',
      harvestingVideos: ['assets/videos/BWRAC_Eucalypt_Browse.mp4'],
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