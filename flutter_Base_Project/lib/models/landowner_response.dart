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
}