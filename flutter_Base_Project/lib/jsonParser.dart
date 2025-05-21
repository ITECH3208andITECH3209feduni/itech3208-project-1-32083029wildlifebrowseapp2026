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
    required this.items,
    required this.animal,
    required this.address,
    required this.postcode,
    required this.delivery_ID,
    this.specifications,
  });

  final String name;
  final List<Items> items;
  final List<Animal> animal;
  final String address;
  final int postcode;
  final int delivery_ID;
  final String? specifications;

  factory Request.fromJson(Map<String, dynamic> testRequestJson) {
    final name = testRequestJson['name'] as String;
    // if (name is! String) {
    //   // will throw if name is missing or not a String
    //   throw FormatException(
    //     'Invalid JSON: required "name" field of type String in $testRequestJson',
    //   );
    // }

    final itemsData = testRequestJson['items'] as List<dynamic>;
    // if (itemsData is! List<dynamic>) {
    //   // will throw if items is missing or not a List
    //   throw FormatException(
    //     'Invalid JSON: required "items" array of type List<dynamic> in $testRequestJson',
    //   );
    // }

    final animalsData = testRequestJson['animal'] as List<dynamic>;
    // if (animalsData is! List<dynamic>) {
    //   // will throw if animal is missing or not a object
    //   throw FormatException(
    //     'Invalid JSON: required "animal" object of type Animal in $testRequestJson',
    //   );
    // }

    final address = testRequestJson['address'] as String;
    // if (address is! String) {
    //   // will throw if address is missing or not a String
    //   throw FormatException(
    //     'Invalid JSON: required "address" field of type int in $testRequestJson',
    //   );
    // }

    final postcode = testRequestJson['postcode'] as int;
    // if (postcode is! int) {
    //   // will throw if postcode is missing or not a Int
    //   throw FormatException(
    //     'Invalid JSON: required "postcode" field of type int in $testRequestJson',
    //   );
    // }

    final delivery_ID = testRequestJson['delivery_ID'] as int;
    // if (delivery_ID is! int) {
    //   // will throw if delivery_ID is missing or not a Int
    //   throw FormatException(
    //     'Invalid JSON: required "delivery_ID" field of type int in $testRequestJson',
    //   );
    // }

    final specifications = testRequestJson['specifications'] as String?;

    return Request(
      name: name,
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
    // if (plant_ID is! int) {
    //   // will throw if plant_ID is missing or not a Int
    //   throw FormatException(
    //     'Invalid JSON: required "plant_ID" field of type int in $testRequestJson',
    //   );
    // }

    final quantity = testRequestJson['quantity'] as int; 
    // if (quantity is! int) {
    //   // will throw if quantity is missing or not a Int
    //   throw FormatException(
    //     'Invalid JSON: required "quantity" field of type int in $testRequestJson',
    //   );
    // }

    final plant_Name = testRequestJson['plant_Name'] as String;
    // if (plant_Name is! String) {
    //   // will throw if plant_Name is missing or not a String
    //   throw FormatException(
    //     'Invalid JSON: required "plant_Name" field of type int in $testRequestJson',
    //   );
    // }

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
    // if (animal_ID is! int) {
    //   // will throw if animal_ID is missing or not a Int
    //   throw FormatException(
    //     'Invalid JSON: required "animal_ID" field of type int in $testRequestJson',
    //   );
    // }

    final animal_Name = testRequestJson['animal_Name'] as String;
    // if (animal_Name is! String) {
    //   // will throw if animal_Name is missing or not a String
    //   throw FormatException(
    //     'Invalid JSON: required "animal_Name" field of type int in $testRequestJson',
    //   );
    // }

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