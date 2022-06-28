import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:todoist/providers/providers.dart';
import 'package:todoist/screens/screens.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<Widget> pages = [
    const DoneTasks(),
    const AddedTasks(),
    const SettingsScreen()
  ];
  late DateTime time;
  @override
  void initState() {
    time = DateTime.now();
    initialization();
    // Provider.of<TaskManager>(context, listen: false).initDatabase();
    super.initState();
  }

  void initialization() async {
    await Future.delayed(const Duration(seconds: 2));
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskManager>(builder: ((context, taskManager, child) {
      taskManager.initDatabase();
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: pages[taskManager.getCurrentTab],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.check_box),
              label: 'Done',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Tasks',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          currentIndex: taskManager.getCurrentTab,
          selectedItemColor: Colors.blue.shade300,
          onTap: taskManager.gotoTab,
        ),
      );
    }));
  }
}
