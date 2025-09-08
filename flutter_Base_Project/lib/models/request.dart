import 'deliveryItems.dart';

class Request {
  Request({
    required this.postcode,
    this.requestDetails,
    required this.request_ID,
    required this.timestamp,
    this.assigned_User_ID,
    required this.requester_ID,
    required this.status_Num,
    required this.delivery_items,
    required this.animal_ID,
  });

  final int postcode;
  final String? requestDetails;
  final String request_ID;
  final String timestamp;
  String? assigned_User_ID;
  final String requester_ID;
  int status_Num;
  final List<DeliveryItems> delivery_items;
  final String animal_ID;

  // Helper method to create an empty request
  factory Request.empty() {
    return Request(
      postcode: 0,
      request_ID: '',
      timestamp: '',
      requester_ID: '',
      status_Num: 0,
      delivery_items: [],
      animal_ID: '',
    );
  }

  // Items helper methods
  List<String> getPlantID() {
    return delivery_items.map((a) => a.plant_ID).toList();
  }

  List<int> getPlantQuantities() {
    return delivery_items.map((a) => a.quantity).toList();
  }

  set updateState(int newState) {
    status_Num = newState;
  }

  set assignGatherer(String newState) {
    assigned_User_ID = newState;
  }

  static List<DeliveryItems> _parseDeliveryItems(dynamic itemsData) {
    if (itemsData == null || itemsData is! List<dynamic>) {
      return [];
    }
    
    return itemsData.map((item) {
      try {
        return DeliveryItems.fromJson(item as Map<String, dynamic>);
      } catch (e) {
        print('Error parsing delivery item: $e');
        // Return a empty DeliveryItems instance if parsing fails
        return DeliveryItems(plant_ID: '', quantity: 0);
      }
    }).toList();
  }

  factory Request.fromJson(Map<String, dynamic> requestJson) {
    try {
      return Request(
        postcode: (requestJson['postcode'] as int?) ?? 0,
        requestDetails: requestJson['requestDetails']?.toString(),
        request_ID: requestJson['request_ID']?.toString() ?? '',
        timestamp: requestJson['timestamp']?.toString() ?? '',
        assigned_User_ID: requestJson['assigned_User_ID']?.toString(),
        requester_ID: requestJson['requester_ID']?.toString() ?? '',
        status_Num: (requestJson['status_Num'] as num?)?.toInt() ?? 0,
        delivery_items: _parseDeliveryItems(requestJson['delivery_items']),
        animal_ID: requestJson['animal_ID']?.toString() ?? '',
      );
    } catch (e) {
      print('Error parsing Request: $e');
      return Request.empty();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'postcode': postcode,
      'requestDetails': requestDetails,
      'request_ID': request_ID,
      'timestamp': timestamp,
      'assigned_User_ID': assigned_User_ID,
      'requester_ID': requester_ID,
      'status_Num': status_Num,
      'delivery_items': delivery_items.map((e) => e.toJson()).toList(),
      'animal_ID': animal_ID,
    };
  }
}