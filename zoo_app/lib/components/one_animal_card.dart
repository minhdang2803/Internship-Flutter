import 'package:demo_firstapp/models/animal.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OneAnimalCard extends StatelessWidget {
  const OneAnimalCard({Key? key, required this.animal}) : super(key: key);
  final Animal animal;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [buildPicture(context), buildContent(context)],
          ),
        ),
      ),
    );
  }

  Widget buildPicture(context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      constraints: BoxConstraints(maxHeight: 400),
      child: Image(
        image: NetworkImage(
          animal.imageLink.toString(),
        ),
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildContent(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Animal name: ${animal.name}',
            style:
                GoogleFonts.openSans(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          Text(
            'Animal type: ${animal.animalType}',
            style:
                GoogleFonts.openSans(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          Text(
            'Active time: ${animal.activeTime}',
            style:
                GoogleFonts.openSans(fontSize: 14, fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}
