import 'dart:convert';

class Animal {
  Animal({
    required this.name,
    required this.latinName,
    required this.animalType,
    required this.activeTime,
    required this.lengthMin,
    required this.lengthMax,
    required this.weightMin,
    required this.weightMax,
    required this.lifespan,
    required this.habitat,
    required this.diet,
    required this.geoRange,
    required this.imageLink,
    required this.id,
  });

  final String name;
  final String latinName;
  final String animalType;
  final String activeTime;
  final String lengthMin;
  final String lengthMax;
  final String weightMin;
  final String weightMax;
  final String lifespan;
  final String habitat;
  final String diet;
  final String geoRange;
  final String imageLink;
  final int id;

  Animal copyWith({
    required String name,
    required String latinName,
    required String animalType,
    required String activeTime,
    required String lengthMin,
    required String lengthMax,
    required String weightMin,
    required String weightMax,
    required String lifespan,
    required String habitat,
    required String diet,
    required String geoRange,
    required String imageLink,
    required int id,
  }) =>
      Animal(
        name: name,
        latinName: latinName,
        animalType: animalType,
        activeTime: activeTime,
        lengthMin: lengthMin,
        lengthMax: lengthMax,
        weightMin: weightMin,
        weightMax: weightMax,
        lifespan: lifespan,
        habitat: habitat,
        diet: diet,
        geoRange: geoRange,
        imageLink: imageLink,
        id: id,
      );

  factory Animal.fromRawJson(String str) => Animal.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Animal.fromJson(Map<String, dynamic> json) => Animal(
        name: json["name"],
        latinName: json["latin_name"],
        animalType: json["animal_type"],
        activeTime: json["active_time"],
        lengthMin: json["length_min"],
        lengthMax: json["length_max"],
        weightMin: json["weight_min"],
        weightMax: json["weight_max"],
        lifespan: json["lifespan"],
        habitat: json["habitat"],
        diet: json["diet"],
        geoRange: json["geo_range"],
        imageLink: json["image_link"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "latin_name": latinName,
        "animal_type": animalType,
        "active_time": activeTime,
        "length_min": lengthMin,
        "length_max": lengthMax,
        "weight_min": weightMin,
        "weight_max": weightMax,
        "lifespan": lifespan,
        "habitat": habitat,
        "diet": diet,
        "geo_range": geoRange,
        "image_link": imageLink,
        "id": id,
      };
}
