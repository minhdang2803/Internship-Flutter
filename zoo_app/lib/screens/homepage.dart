import 'package:demo_firstapp/screens/screens.dart';
import 'package:demo_firstapp/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffffc0cb),
        // foregroundColor: Colors.blue,
        title: Text(
          'ZooTopia',
          style: Theme.of(context).textTheme.headline3,
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [buildBackgroundPicture(), buildContent()],
        ),
      ),
    );
  }

  Image buildBackgroundPicture() {
    return const Image(
      image: AssetImage('assets/zoo1.jpg'),
      height: double.infinity,
      width: double.infinity,
      fit: BoxFit.fill,
    );
  }

  Widget buildContent() {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          buildGetOnlyOne(),
          const SizedBox(height: 10),
          buildGetMany(),
        ],
      ),
    );
  }

  Widget buildGetOnlyOne() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const OneAnimal())),
        style: ElevatedButton.styleFrom(
          primary: const Color(0xffffc0cb).withOpacity(0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          'Get an animal',
          style:
              ZooTheme.lightTextTheme.headline4!.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  Widget buildGetMany() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ManyAnimal())),
        style: ElevatedButton.styleFrom(
          primary: const Color(0xffffc0cb).withOpacity(0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          'Get animals',
          style:
              ZooTheme.lightTextTheme.headline4!.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
