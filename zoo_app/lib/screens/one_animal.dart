import 'package:demo_firstapp/screens/detail_animal.dart';

import '../api.dart';
import 'package:demo_firstapp/models/animal.dart';
import 'package:demo_firstapp/theme.dart';
import 'package:flutter/material.dart';
import 'package:demo_firstapp/components/components.dart';

class OneAnimal extends StatefulWidget {
  const OneAnimal({Key? key}) : super(key: key);

  @override
  State<OneAnimal> createState() => _OneAnimalState();
}

class _OneAnimalState extends State<OneAnimal> {
  late var animal;
  @override
  void initState() {
    super.initState();
    animal = API.getAnimal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffc0cb),
      appBar: AppBar(
        elevation: 2,
        backgroundColor: const Color(0xffffc0cb),
        // foregroundColor: Colors.blue,
        title: Text(
          'An Animals',
          style: Theme.of(context).textTheme.headline3,
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              buildTopBar(),
              Container(child: buildAnimal(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTopBar() {
    return Flexible(
      flex: 1,
      fit: FlexFit.loose,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('Get an animal here', style: ZooTheme.lightTextTheme.headline2),
          IconButton(
            onPressed: () {
              setState(() {
                animal = API.getAnimal();
              });
            },
            icon: const Icon(
              Icons.replay_outlined,
              size: 30,
            ),
          )
        ],
      ),
    );
  }

  Widget buildAnimal(BuildContext context) {
    return FutureBuilder(
      future: animal,
      builder: (context, AsyncSnapshot<Animal> snapshot) {
        if (snapshot.hasData) {
          return GestureDetector(
            child: OneAnimalCard(animal: snapshot.data!),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailedInfoAnimal(
                    animal: snapshot.data!, name: snapshot.data!.name),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
