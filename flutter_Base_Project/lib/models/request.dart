import 'animal.dart';
import 'items.dart';

class Request {
  Request({
    required this.name,
    required this.state,
    required this.time,
    required this.items,
    required this.animal,
    required this.address,
    required this.postcode,
    required this.delivery_ID,
    this.specifications,
  });

  final String name;
  String state;
  final String time;
  final List<Items> items;
  final List<Animal> animal;
  final String address;
  final int postcode;
  final int delivery_ID;
  final String? specifications;


  // Animal helper methods
  // Gets animal names as a list
  List<String> getAnimalNames() {
    return animal.map((a) => a.animal_Name).toList();
  }

  // Gets animals by ID
  Animal? findAnimalById(int animalId) {
    return animal.firstWhere((a) => a.animal_ID == animalId);
  }


  // Items helper methods
  // Gets plant names as a list
  List<String> getPlantNames() {
    return items.map((a) => a.plant_Name).toList();
  }

 // Gets plant quantities as list
  List<int> getPlantQuantities() {
    return items.map((a) => a.quantity).toList();
  }

  // Gets plants by ID
  Items? findPlantById(int plant_ID) {
    return items.firstWhere((a) => a.plant_ID == plant_ID);
  }


  set updateState(String newState) {
    state = newState;
  }

  factory Request.fromJson(Map<String, dynamic> requestJson) {
    final name = requestJson['name'] as String;
    // if (name is! String) {
    //   // will throw if name is missing or not a String
    //   throw FormatException(
    //     'Invalid JSON: required "name" field of type String in $requestJson',
    //   );
    // }

    final state = requestJson['state'] as String;
    final time = requestJson['time'] as String;
    final itemsData = requestJson['items'] as List<dynamic>;
    final animalsData = requestJson['animal'] as List<dynamic>;
    final address = requestJson['address'] as String;
    final postcode = requestJson['postcode'] as int;
    final delivery_ID = requestJson['delivery_ID'] as int;
    final specifications = requestJson['specifications'] as String?;

    return Request(
      name: name,
      state: state,
      time: time,
      items: itemsData
      .map((itemData) =>
        Items.fromJson(itemData as Map<String, dynamic>))
      .toList(),
      animal: animalsData
      .map((animalData) =>
        Animal.fromJson(animalData as Map<String, dynamic>))
      .toList(),
      address: address,
      postcode: postcode,
      delivery_ID: delivery_ID,
      specifications: specifications,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'state': state,
      'time': time,
      'itemsData': items,
      'animalsData': animal,
      'address': address,
      'postcode': postcode,
      'delivery_ID': delivery_ID,
      'specifications': specifications,
    };
  }
}