import 'request.dart';

class Response {
  final String table;
  final int count;
  final List<Request> items;
  final dynamic startKey;

  Response({
    required this.table,
    required this.count,
    required this.items,
    this.startKey,
  });

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      table: (json['table'] as String?) ?? '',
      count: (json['count'] as int?) ?? 0,
      items: _parseItems(json['items']),
      startKey: json['startKey'],
    );
  }

  static List<Request> _parseItems(dynamic itemsData) {
    if (itemsData == null || itemsData is! List<dynamic>) {
      return [];
    }
    
    return itemsData.map((item) {
      try {
        return Request.fromJson(item as Map<String, dynamic>);
      } catch (e) {
        print('Error parsing request item: $e');
        return Request.empty();
      }
    }).toList();
  }
}