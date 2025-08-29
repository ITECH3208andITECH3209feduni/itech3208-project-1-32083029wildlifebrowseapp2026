import 'dart:convert';
import 'models/request.dart';
import 'models/items.dart';
import 'models/animal.dart';

Request jsonParser(String data) {
// (Request, Items, Animal) jsonParser(String data) {
    final parsedJson = jsonDecode(data) as Map<String, dynamic>;
    final request = Request.fromJson(parsedJson);
    
    // Will need to iterate over all objects in item array
    // final item = request.items[0]; 
    // final animal = request.animal[0];
  // return (request, item, animal);
  return request;
}