import 'dart:convert';
import 'models/request.dart';
import 'models/items.dart';
import 'models/animal.dart';

// T represents a generic type
// The arg passed to fromJson param must be in the form of <class>.fromJson
// Therefore the class must have fromJson() defined
T jsonToObject<T>(String data, T Function(Map<String, dynamic>) fromJson) {
    final parsedJson = jsonDecode(data) as Map<String, dynamic>;
    return fromJson(parsedJson);
}