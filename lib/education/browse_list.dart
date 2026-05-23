import 'package:flutter/material.dart';
import '../models/browseInformation.dart';
import 'browse_detail.dart';

class BrowseListPage extends StatefulWidget {
  const BrowseListPage({super.key});

  @override
  _BrowseListPageState createState() => _BrowseListPageState();
}

class _BrowseListPageState extends State<BrowseListPage> {
  final List<Browse> allBrowses = [
    Browse(
      id: '1',
      commonName: 'Southern blue gum, Blue gum',
      latinName: 'Eucalyptus globulus',
      topImageUrl: 'assets/images/manna_gum_m_morey_01_copyright.jpg',
      description:
          'A species of flowering plant in the family Myrtaceae. It is a tall, evergreen tree, with four subspecies, all endemic to southeastern Australia',
      leafShape: 'Lanceolate (Long narrow leaf shape pointed like a lance)',
      leafImageUrl: 'assets/images/manna_gum_m_morey_02_copyright.jpg',
      plantShape: 'Tall tree with a dense canopy',
      plantImageUrl: 'assets/images/manna_gum_m_morey_03_copyright.jpg',
      barkTexture: 'Usually smooth and white to cream-coloured',
      barkImageUrl: 'assets/images/manna_gum_m_morey_04_copyright.jpg',
      flowers:
          'Ribbed flower buds arranged singly or in groups of three or seven with white-coloured flowers',
      flowersImageUrl: 'assets/images/manna_gum_m_morey_05_copyright.jpg',
      harvestingVideos: ['assets/videos/BWRAC_Eucalypt_Browse.mp4'],
    ),
    Browse(
      id: '2',
      commonName: 'Manna gum, White gum, Ribbon gum',
      latinName: 'Eucalyptus viminalis',
      topImageUrl: 'assets/images/blueGumNut.jpg',
      description:
          'Ranges in height from small to very tall, typically about 50m in height but can reach 90m. Endemic to southeastern Australia',
      leafShape:
          'Lanceolate (Long narrow leaf shape pointed like a lance) with a slight curve',
      leafImageUrl: 'assets/images/blueGumLeaf.jpg',
      plantShape: 'Adult leaves are arranged alternately',
      plantImageUrl: 'assets/images/blueGumTree.jpg',
      barkTexture:
          'Has smooth, often powdery, white to pale brown bark that it sheds in long ribbons',
      barkImageUrl: 'assets/images/blueGumBark.jpg',
      flowers:
          'Ribbed flower buds arranged singly or in groups of three or seven with white-coloured flowers. Fruit are woody and cup-shaped',
      flowersImageUrl: 'assets/images/blueGumFlower.jpg',
      harvestingVideos: ['assets/videos/BWRAC_Eucalypt_Browse.mp4'],
    ),
    Browse(
      id: '3',
      commonName: 'Banksia',
      latinName: 'Banksia',
      topImageUrl: 'assets/images/Banksia_04_M_Morey_flower_COPYRIGHT.jpg',
      description:
          'Banksia is a flowering shrub or tree of the Proteaceae family. They are evergreen plants. They range from <1 metre to over 20 metres. Mostly located in temperate areas, though some are in arid and tropical areas, species is endemic to Australia except for one which is both native to New Guinea and Australia',
      leafShape:
          'Most leaves of the Banksia are green and get wider as they near the end of the leaf before sharply curving in, forming a semi-cirle',
      leafImageUrl: 'assets/images/Banksia_09_M_Morey_leaf_COPYRIGHT.jpg',
      plantShape:
          'Some Banksia look like a shrub while others look like a normal, standard tree',
      plantImageUrl: 'assets/images/Banksia_08_M_Morey_tree.jpg',
      barkTexture:
          'For Banksia species that are trees, they have a rough texture and are coloured with different shades of browns with both light and dark shades present',
      barkImageUrl: 'assets/images/Banksia_06_M_Morey_bark_COPYRIGHT.jpg',
      flowers:
          'The flowers of a Banksia are unique as they look like a large cylinder, usually yellow, but red, orange, pink and purple flowers do exist. Their flowers are long, thin lines surrounding the core of where they grow out from ',
      flowersImageUrl: 'assets/images/Banksia_04_M_Morey_flower_COPYRIGHT.jpg',
      harvestingVideos: ['assets/videos/BWRAC_Eucalypt_Browse.mp4'],
    ),
    Browse(
      id: '4',
      commonName: 'Bottlebrush',
      latinName: 'Callistemon',
      topImageUrl: 'assets/images/Callistemon_flower.jpg',
      description:
          'Callistemon is a genus of shrub in the family Myrtaceae. Callistemon are evergreen plants, they can range from <1 metre to over 5 metres high, depending on the species. Endemic to most temperate and tropical regions of Australia',
      leafShape:
          'The leaves of a bottlebrush plant are generally long, thin and narrow',
      leafImageUrl: 'assets/images/Callistemon_leaf.jpg',
      plantShape:
          'Height various between species. All species have a dense bushy foliage',
      plantImageUrl: 'assets/images/Callistemon_tree.jpg',
      barkTexture:
          'Jagged and rough looking bark ranging from feeling hard to almost soft and like paper',
      barkImageUrl: 'assets/images/Callistemon_nuts.jpg',
      flowers: 'Red brush-like flowers arranged in a cylindrical shape',
      flowersImageUrl: 'assets/images/Callistemon_flower.jpg',
      harvestingVideos: ['assets/videos/BWRAC_Eucalypt_Browse.mp4'],
    ),
    Browse(
      id: '5',
      commonName: 'Camellia',
      latinName: 'Camellia',
      topImageUrl: 'assets/images/Camellia_M_Morey_flower_COPYRIGHT.jpg',
      description:
          "Cammellia is a large flowering plant belonging to Theaceae family, they are evergreen plants with some species reaching heights of above 10 metres. The species is not native to Australia, with it having been imported in the 1800's",
      leafShape:
          'The leaves of a Camellia plant are long and wide with an almost leathery feel to them, they are a deep green colour with a glossy look to them',
      leafImageUrl: 'assets/images/Camellia_M_Morey_leaf_COPYRIGHT.jpg',
      plantShape: 'The foliage of the Camellia gives the plant a rounded shape',
      plantImageUrl: 'assets/images/Camellia_M_Morey_tree.jpg',
      barkTexture:
          'The texture of the Camellia bark is smooth, it has a range of colours from biege to a dull brown',
      barkImageUrl: 'assets/images/Camellia_M_Morey_nut.jpg',
      flowers:
          'The flowers of the plant usually have a red or pink colour to them but some species have white petals',
      flowersImageUrl: 'assets/images/Camellia_M_Morey_flower_COPYRIGHT.jpg',
      harvestingVideos: ['assets/videos/BWRAC_Eucalypt_Browse.mp4'],
    ),
    Browse(
      id: '6',
      commonName: 'Correa',
      latinName: 'Correa',
      topImageUrl: 'assets/images/Correa_M_Morey_flower_COPYRIGHT.jpg',
      description:
          'Correa is a genus of 11 flowering plants which belong to the Rutaceae family. They are an evergreen plant, they average a few metres tall, although one species can reach up to 16 metres. It is endemic to Australia with each state having at least 1 species native to there. Victoria has 6 Correa native to it',
      leafShape:
          'Leaves of the Correa plant are green, they sport a circular and oval shape to them',
      leafImageUrl: 'assets/images/Correa_M_Morey_leaf_COPYRIGHT.jpg',
      plantShape:
          'Due to the number of different species, the plant can take on different looks, such as a dense small bush, or branching tower of sticks',
      plantImageUrl: 'assets/images/Correa_M_Morey_tree.jpg',
      barkTexture: 'The bark of Correa plants has a brown, smooth texture',
      barkImageUrl: 'assets/images/Correa_M_Morey_tree.jpg',
      flowers:
          'The colours of the Correa plant can range from green, pink, white, greyish-purple. Every species generally holds the same shape of 4 petals stretching out, making a tube shape before flairing out, with the stamens sticking out',
      flowersImageUrl: 'assets/images/Correa_M_Morey_flower_COPYRIGHT.jpg',
      harvestingVideos: ['assets/videos/BWRAC_Eucalypt_Browse.mp4'],
    ),
    Browse(
      id: '7',
      commonName: 'Spider Flowers',
      latinName: 'Grevillea',
      topImageUrl: 'assets/images/Grevillea_M_Morey_flower_COPYRIGHT.jpg',
      description:
          'Grevillea is a flowering plant belonging to the Proteaceae family. Grevilleas are a type of evergreen plant. The heights of these plants ranges from species to species, most average arround 1-2 metres tall, one species, G.robusta, can reach heights of up to 40 metres. Over 300 (~360-380) species are endemic to Australia, with around a dozen species endemic to places outside Australia',
      leafShape:
          'The sheer amount of different species means that there are many different ways the leaves can look, some dark green lines almost like blades of grass, some glossy green wide ones, and some with green leaves somewhat resembling tridents',
      leafImageUrl: 'assets/images/Grevillea_M_Morey_tree.jpg',
      plantShape:
          'The different Grevillea species can range from small bushes with red flowers to a towering tree with yellow flowers',
      plantImageUrl: 'assets/images/Grevillea_M_Morey_tree.jpg',
      barkTexture:
          'Spider Flowers range between bark types, with some being green and smooth, some being brown with red accents to brown rough bark',
      barkImageUrl: 'assets/images/Grevillea_M_Morey_tree.jpg',
      flowers:
          "The flowers of the Grevillea range between multiple colours, bright reds, oranges and pinks, to whites, yellows and black with green spots. Their common name reportably originates from them resembling a spider's web",
      flowersImageUrl: 'assets/images/Grevillea_M_Morey_flower_COPYRIGHT.jpg',
      harvestingVideos: ['assets/videos/BWRAC_Eucalypt_Browse.mp4'],
    ),
    Browse(
      id: '8',
      commonName: 'Lilly Pilly',
      latinName: 'Syzygium Smithii',
      topImageUrl: 'assets/images/Lilly_Pilly_M_Morey_leaf_COPYRIGHT.jpg',
      description:
          "Syzygium Smithii is an evergreen tree which belongs to the Myrtaceae family. The tree can reach heights of up to 20 metres. It is endemic to Australia and its natural habitat is from North Queensland down to Southern Victoria",
      leafShape:
          'The Lilly Pilly has green leaves which appear glossy and are widest in the middle',
      leafImageUrl: 'assets/images/Lilly_Pilly_M_Morey_leaf_COPYRIGHT.jpg',
      plantShape:
          'The tree is very foliage dense, almost looking spherical when it is many years old',
      plantImageUrl: 'assets/images/Lilly_Pilly_M_Morey_tree.jpg',
      barkTexture:
          'The bark of the Lilly Pilly is brown and rough, somewhat said to resemble scales',
      barkImageUrl: 'assets/images/Lilly_Pilly_M_Morey_tree.jpg',
      flowers:
          'When grown, the flowers are coloured white and look spikey, additionally the Lilly Pilly can grow white coloured berries as well',
      flowersImageUrl: 'assets/images/Lilly_Pilly_M_Morey_leaf_COPYRIGHT.jpg',
      harvestingVideos: ['assets/videos/BWRAC_Eucalypt_Browse.mp4'],
    ),
  ];

  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final filteredBrowses =
        allBrowses.where((browse) {
          final query = searchQuery.toLowerCase();
          return browse.commonName.toLowerCase().contains(query) ||
              browse.latinName.toLowerCase().contains(query);
        }).toList();

    return Scaffold(
      appBar: AppBar(title: Text("Browse catalog")),
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

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: Text(browse.commonName),
                                content: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(browse.topImageUrl),
                                      const SizedBox(height: 10),
                                      Text(browse.description),

                                      const SizedBox(height: 10),

                                      Text("Leaf: ${browse.leafShape}"),
                                      const SizedBox(height: 5),

                                      Text("Plant: ${browse.plantShape}"),
                                      const SizedBox(height: 5),

                                      Text("Bark: ${browse.barkTexture}"),
                                      const SizedBox(height: 5),

                                      Text("Flowers: ${browse.flowers}"),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Close"),
                                  ),
                                ],
                              ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 28,
                        backgroundImage: AssetImage(browse.topImageUrl),
                      ),
                    ),
                    title: Text(
                      browse.commonName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(browse.latinName),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BrowseDetailPage(browse: browse),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
