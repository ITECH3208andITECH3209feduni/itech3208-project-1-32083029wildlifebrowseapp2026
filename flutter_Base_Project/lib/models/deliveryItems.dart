class DeliveryItems {
  DeliveryItems({
    required this.plant_ID,
    required this.quantity,
    required this.type,
  });

  final String plant_ID;
  final int quantity;
  final String type;


  factory DeliveryItems.fromJson(Map<String, dynamic> requestJson) {
    final plant_ID = requestJson['plant_ID'] as String; 
    final quantity = requestJson['quantity'] as int;
    final type = requestJson['type'] as String? ?? 'branch/es';

    return DeliveryItems(
      plant_ID: plant_ID,
      quantity: quantity,
      type: type,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plant_ID': plant_ID,
      'quantity': quantity,
      'type': type,
    };
  }
}