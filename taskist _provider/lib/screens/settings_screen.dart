import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoist/screens/webview_screen.dart';
import 'package:todoist/providers/theme_manager.dart';

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
        Expanded(
          child: Divider(
            color: Theme.of(context).colorScheme.primary,
            thickness: 2,
          ),
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.1),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: "Task",
                  style: Theme.of(context)
                      .textTheme
                      .headline3!
                      .copyWith(fontSize: 30, fontWeight: FontWeight.bold)),
              TextSpan(
                  text: "Settings",
                  style: Theme.of(context).textTheme.headline3!.copyWith(
                      fontSize: 30,
                      color: Colors.grey,
                      fontWeight: FontWeight.w300)),
            ],
          ),
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.1),
        Expanded(
          child: Divider(
            color: Theme.of(context).colorScheme.primary,
            thickness: 2,
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
            buildDarkModeOption(context),
            GestureDetector(
              child: buildEachOption(
                Image(
                    image: const AssetImage(
                      'assets/twitter.png',
                    ),
                    height: MediaQuery.of(context).size.height * 0.025),
                'Twitter',
                const Icon(Icons.arrow_right),
              ),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WebviewScreen())),
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

  Widget buildDarkModeOption(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.dark_mode),
      title: const Text('Dark mode'),
      trailing: Switch(
        value: Provider.of<TaskistThemeProvider>(context, listen: false)
            .getDarkMode,
        onChanged: (value) {
          Provider.of<TaskistThemeProvider>(context, listen: false)
              .swapTheme(value);
        },
      ),
    );
  }
}
