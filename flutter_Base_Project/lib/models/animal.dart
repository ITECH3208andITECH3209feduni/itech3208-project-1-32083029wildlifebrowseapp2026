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