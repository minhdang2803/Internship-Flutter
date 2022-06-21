import 'package:flutter/material.dart';
import 'package:todoist/theme.dart';
import 'screens/screens.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const TaskistClone());
}

class TaskistClone extends StatefulWidget {
  const TaskistClone({Key? key}) : super(key: key);

  @override
  State<TaskistClone> createState() => _TaskistCloneState();
}

class _TaskistCloneState extends State<TaskistClone> {
  ThemeData theme = TaskistTheme.light();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      title: "Taskist Clone",
      home: const Homepage(),
    );
  }
}
