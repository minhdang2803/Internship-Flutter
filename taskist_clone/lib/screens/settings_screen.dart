import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.025),
              buildIcon(context),
              SizedBox(height: MediaQuery.of(context).size.height * 0.025),
              buildLine(context),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              buildOptions(context)
            ],
          ),
        ),
      ),
    );
  }

  Image buildIcon(BuildContext context) {
    return Image(
      image: const AssetImage('assets/splash_screen.png'),
      height: MediaQuery.of(context).size.height * 0.06,
    );
  }

  Widget buildLine(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            color: Colors.black,
          ),
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.1),
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                  text: "Task",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  )),
              TextSpan(
                  text: "Settings",
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 30,
                    fontWeight: FontWeight.w400,
                  )),
            ],
          ),
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.1),
        const Expanded(
          child: Divider(
            color: Colors.black,
          ),
        )
      ],
    );
  }

  Widget buildOptions(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            buildEachOption(
                const Icon(Icons.settings), 'Hello World', const Text('1.1.0')),
            buildEachOption(
              Image(
                  image: const AssetImage(
                    'assets/twitter.png',
                  ),
                  height: MediaQuery.of(context).size.height * 0.025),
              'Twitter',
              const Icon(Icons.arrow_right),
            ),
            buildEachOption(
              const Icon(Icons.star_border_outlined, color: Colors.blue),
              'Rate Taskist',
              const Icon(Icons.arrow_right),
            ),
            buildEachOption(
              const Icon(Icons.share, color: Colors.blue),
              'Share Taskist',
              const Icon(Icons.arrow_right),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEachOption(Widget icon, String title, Widget trailing) {
    return ListTile(
      leading: icon,
      title: Text(title),
      trailing: trailing,
    );
  }
}
