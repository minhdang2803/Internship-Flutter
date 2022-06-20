import 'package:flutter/material.dart';
import 'package:demo_firstapp/models/models.dart';

class DetailedInfoAnimal extends StatelessWidget {
  const DetailedInfoAnimal({Key? key, required this.animal, required this.name})
      : super(key: key);
  final Animal animal;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffc0cb),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffffc0cb),
        // foregroundColor: Colors.blue,
        title: Text(
          name,
          style: Theme.of(context).textTheme.headline3,
        ),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(top: 15, right: 15, left: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildPicture(context),
                const SizedBox(height: 10),
                Text('Name: ${animal.name}'),
                Text('Type: ${animal.animalType}'),
                Text('Active time: ${animal.activeTime}'),
                Text('Life Span: ${animal.lifespan}'),
                Text('Max length: ${animal.lengthMax}'),
                Text('Min length: ${animal.lengthMin}'),
                Text('Max weight: ${animal.weightMax}'),
                Text('Min weight: ${animal.weightMin}'),
                Text('Habitat: ${animal.habitat}'),
                Text('Diet: ${animal.diet}'),
                Text('Geomery Range: ${animal.geoRange}'),
                Text('Max weight: ${animal.weightMax}'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPicture(context) {
    return Image(
      image: NetworkImage(animal.imageLink),
      fit: BoxFit.cover,
    );
  }
}
