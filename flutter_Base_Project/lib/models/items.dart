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