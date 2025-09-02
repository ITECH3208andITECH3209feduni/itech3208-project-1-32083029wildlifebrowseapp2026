// import 'animal.dart';
import 'deliveryItems.dart';

// Will need to revamp this to handle Dynamo key values

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
  final String? assigned_User_ID;
  final String requester_ID;
  int status_Num;
  final List<DeliveryItems> delivery_items;
  final String animal_ID;


  // Items helper methods
  // Gets plant names as a list
  // List<String?> getPlantNames() {
  //   return delivery_items.map((a) => a.plant_Name).toList();
  // }

  List<String> getPlantID() {
    return delivery_items.map((a) => a.plant_ID).toList();
  }

 // Gets plant quantities as list
  List<int> getPlantQuantities() {
    return delivery_items.map((a) => a.quantity).toList();
  }

  // Gets plants by ID
  // Items? findPlantById(String plant_ID) {
  //   return delivery_items.firstWhere((a) => a.plant_ID == plant_ID);
  // }


  set updateState(int newState) {
    status_Num = newState;
  }

  factory Request.fromJson(Map<String, dynamic> requestJson) {
    final postcode = requestJson['postcode'] as int;
    final requestDetails = requestJson['requestDetails'] as String?;
    final request_ID = requestJson['request_ID'] as String;
    final timestamp = requestJson['timestamp'] as String;
    final assigned_User_ID = requestJson['assigned_User_ID'] as String?;
    final requester_ID = requestJson['requester_ID'] as String;
    final status_Num = requestJson['status_Num'] as int;
    final itemsData = requestJson['delivery_items'] as List<dynamic>;
    final animal_ID = requestJson['animal_ID'] as String;

    return Request(
      postcode: postcode,
      requestDetails: requestDetails,
      request_ID: request_ID,
      timestamp: timestamp,
      assigned_User_ID: assigned_User_ID,
      requester_ID: requester_ID,
      status_Num: status_Num,
      delivery_items: itemsData
        .map((itemData) => DeliveryItems.fromJson(itemData as Map<String, dynamic>))
        .toList(),
      // delivery_items: itemsData
      // .map((itemData) =>
      //   Items.fromJson(itemData as Map<String, dynamic>))
      // .toList(),
      animal_ID: animal_ID,
    );
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