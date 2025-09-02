class DeliveryItems {
  DeliveryItems({
    required this.plant_ID,
    required this.quantity,
    // this.plant_Name,
  });

  final String plant_ID;
  final int quantity;
  // final String? plant_Name;


  factory DeliveryItems.fromJson(Map<String, dynamic> requestJson) {
    final plant_ID = requestJson['plant_ID'] as String; 
    final quantity = requestJson['quantity'] as int; 
    // final plant_Name = requestJson['plant_Name'] as String?;

    return DeliveryItems(
      plant_ID: plant_ID,
      quantity: quantity,
      // plant_Name: plant_Name,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plant_ID': plant_ID,
      'quantity': quantity,
      // 'plant_Name': plant_Name,
    };
  }
}