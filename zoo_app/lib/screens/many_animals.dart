import 'dart:ffi';

import 'package:flutter/material.dart';
import '../api.dart';
import '../components/components.dart';
import '../theme.dart';
import '../models/models.dart';
import '../screens/screens.dart';

class ManyAnimal extends StatefulWidget {
  const ManyAnimal({Key? key}) : super(key: key);

  @override
  State<ManyAnimal> createState() => _ManyAnimalState();
}

class _ManyAnimalState extends State<ManyAnimal> {
  late var animal;
  @override
  void initState() {
    super.initState();
    animal = API.getListAnimal(8);
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
          'Many Animals',
          style: Theme.of(context).textTheme.headline3,
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: RefreshIndicator(
            onRefresh: () async {
              setState(() {
                animal = API.getListAnimal(10);
                Future.delayed(const Duration(seconds: 3));
              });
            },
            child: Column(
              children: [
                buildTopBar(),
                buildAnimal(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text('Get an animal here', style: ZooTheme.lightTextTheme.headline2),
        IconButton(
          onPressed: () {
            setState(() {
              animal = API.getListAnimal(10);
            });
          },
          icon: const Icon(
            Icons.replay_outlined,
            size: 30,
          ),
        )
      ],
    );
  }

  Widget buildAnimal(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
        future: animal,
        builder: (context, AsyncSnapshot<List<Animal>> snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(height: 5),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) => GestureDetector(
                child: OneAnimalCard(
                  animal: snapshot.data![index],
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailedInfoAnimal(
                        animal: snapshot.data![index],
                        name: snapshot.data![index].name),
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
