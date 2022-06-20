import 'dart:convert';
import './models/models.dart';
import 'package:http/http.dart' as http;

class API {
  static Future<Animal> getAnimal() async {
    final response = await http
        .get(Uri.parse('https://zoo-animal-api.herokuapp.com/animals/rand'));
    if (response.statusCode == 200) {
      return Animal.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Fail to load an animal');
    }
  }

  static Future<List<Animal>> getListAnimal(int number) async {
    var response = await http.get(
        Uri.parse('https://zoo-animal-api.herokuapp.com/animals/rand/$number'));
    if (response.statusCode == 200) {
      List<Map<String, dynamic>> listAnimals =
          (jsonDecode(response.body) as List<dynamic>)
              .map((e) => (e as Map<String, dynamic>))
              .toList();
      return listAnimals.map((e) => Animal.fromJson(e)).toList();
    } else {
      throw Exception('Fail to load an animal');
    }
  }
}
