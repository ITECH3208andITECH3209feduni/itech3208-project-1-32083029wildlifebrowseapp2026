import 'dart:convert';

(Request, Items, Animal) jsonParser(String data) {
    final parsedJson = jsonDecode(data) as Map<String, dynamic>;
    final request = Request.fromJson(parsedJson);
    
    // Will need to iterate over all objects in item array
    final item = request.items[0]; 
    final animal = request.animal[0];
  return (request, item, animal);
}

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

  set updateState(String newState) {
    state = newState;
  }

  factory Request.fromJson(Map<String, dynamic> testRequestJson) {
    final name = testRequestJson['name'] as String;
    // if (name is! String) {
    //   // will throw if name is missing or not a String
    //   throw FormatException(
    //     'Invalid JSON: required "name" field of type String in $testRequestJson',
    //   );
    // }

    final state = testRequestJson['state'] as String;
    final time = testRequestJson['time'] as String;
    final itemsData = testRequestJson['items'] as List<dynamic>;
    final animalsData = testRequestJson['animal'] as List<dynamic>;
    final address = testRequestJson['address'] as String;
    final postcode = testRequestJson['postcode'] as int;
    final delivery_ID = testRequestJson['delivery_ID'] as int;
    final specifications = testRequestJson['specifications'] as String?;

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

class Items {
  Items({
    required this.plant_ID,
    required this.quantity,
    required this.plant_Name,
  });

  final int plant_ID;
  final int quantity;
  final String plant_Name;


  factory Items.fromJson(Map<String, dynamic> testRequestJson) {

    // if (!testRequestJson.containsKey('plant_ID')) {
    //   throw FormatException('Required field "plant_ID" is missing');
    // }
    
    final plant_ID = testRequestJson['plant_ID'] as int; 
    final quantity = testRequestJson['quantity'] as int; 
    final plant_Name = testRequestJson['plant_Name'] as String;

    return Items(
      plant_ID: plant_ID,
      quantity: quantity,
      plant_Name: plant_Name,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plant_ID': plant_ID,
      'quantity': quantity,
      'plant_Name': plant_Name,
    };
  }
}

class Animal {
  Animal({
    required this.animal_ID,
    required this.animal_Name,
  });

  final int animal_ID;
  final String animal_Name;

  factory Animal.fromJson(Map<String, dynamic> testRequestJson) {
    final animal_ID = testRequestJson['animal_ID'] as int; 
    final animal_Name = testRequestJson['animal_Name'] as String;

    return Animal(
      animal_ID: animal_ID,
      animal_Name: animal_Name,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'animal_ID': animal_ID,
      'animal_Name': animal_Name,
    };
  }
}