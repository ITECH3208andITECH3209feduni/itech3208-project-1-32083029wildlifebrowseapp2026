class Browse {
  final String id;
  final String commonName;
  final String latinName;
  final String topImageUrl;
  final String description;
  final String leafShape;
  final String leafImageUrl;
  final String plantShape;
  final String plantImageUrl;
  final String barkTexture;
  final String barkImageUrl;
  final String flowers;
  final String flowersImageUrl;

  Browse({
    required this.id,
    required this.commonName,
    required this.latinName,
    required this.topImageUrl,
    required this.description,
    required this.leafShape,
    required this.leafImageUrl,
    required this.plantShape,
    required this.plantImageUrl,
    required this.barkTexture,
    required this.barkImageUrl,
    required this.flowers,
    required this.flowersImageUrl,
  });

  factory Browse.fromJson(Map<String, dynamic> browseJson) {

    final id = browseJson['id'] as String;
    final commonName = browseJson['commonName'] as String;
    final latinName = browseJson['latinName'] as String;
    final topImageUrl = browseJson['topImageUrl'] as String;
    final description = browseJson['description'] as String;
    final leafShape = browseJson['leafShape'] as String;
    final leafImageUrl = browseJson['leafImageUrl'] as String;
    final plantShape = browseJson['plantShape'] as String;
    final plantImageUrl = browseJson['plantImageUrl'] as String;
    final barkTexture = browseJson['barkTexture'] as String;
    final barkImageUrl = browseJson['barkImageUrl'] as String;
    final flowers = browseJson['flowers'] as String;
    final flowersImageUrl = browseJson['flowersImageUrl'] as String;

    return Browse(
      id: id,
      commonName: commonName,
      latinName: latinName,
      topImageUrl: topImageUrl,
      description: description,
      leafShape: leafShape,
      leafImageUrl: leafImageUrl,
      plantShape: plantShape,
      plantImageUrl: plantImageUrl,
      barkTexture: barkTexture,
      barkImageUrl: barkImageUrl,
      flowers: flowers,
      flowersImageUrl: flowersImageUrl,
    );
  }

  // Prob won't need this
  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'commonName': commonName,
  //     'latinName': latinName,
  //     'topImageUrl': topImageUrl,
  //     'description': description,
  //     'leafShape': leafShape,
  //     'leafImageUrl': leafImageUrl,
  //     'plantShape': plantShape,
  //     'plantImageUrl': plantImageUrl,
  //     'barkTexture': barkTexture,
  //     'barkImageUrl': barkImageUrl,
  //     'flowers': flowers,
  //     'flowersImageUrl': flowersImageUrl,
  //   };
  // }
}