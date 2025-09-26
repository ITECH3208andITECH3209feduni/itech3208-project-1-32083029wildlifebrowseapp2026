import 'landowner.dart';

class LandOwnerResponse {
  final String table;
  final int count;
  final List<Landowner> items;
  final dynamic startKey;

  LandOwnerResponse({
    required this.table,
    required this.count,
    required this.items,
    this.startKey,
  });

  factory LandOwnerResponse.fromJson(Map<String, dynamic> json) {
    return LandOwnerResponse(
      table: (json['table'] as String?) ?? '',
      count: (json['count'] as int?) ?? 0,
      items: _parseItems(json['items']),
      startKey: json['startKey'],
    );
  }

  static List<Landowner> _parseItems(dynamic itemsData) {
    if (itemsData == null || itemsData is! List<dynamic>) {
      return [];
    }
    
    return itemsData.map((item) {
      try {
        return Landowner.fromJson(item as Map<String, dynamic>);
      } catch (e) {
        print('Error parsing request item: $e');
        return Landowner.empty();
      }
    }).toList();
  }

  // Method to return a filtered list of Landowners based on a given filter (type of browse)
  List<Landowner> filterItems(List<String> filter) {
  List<Landowner> filteredList = [];

  for (Landowner testedLandowner in items) {
    // assuming getBrowseNames() returns List<String>
    List<String> browseNames = testedLandowner.getBrowseNames();

    // Check if any of the filter items match the browse names
    bool matches = filter.any((f) => browseNames.contains(f));

    if (matches) {
      filteredList.add(testedLandowner);
    }
  }

  return filteredList;
}
}