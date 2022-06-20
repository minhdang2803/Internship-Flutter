import 'package:flutter/material.dart';
import 'package:todoist/models/models.dart';
import 'package:todoist/theme.dart';
import 'screens/screens.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskistAdapter());
  Hive.registerAdapter(TasksTableAdapter());
  Hive.registerAdapter(TaskAdapter());
  Hive.openBox<Taskist>('taskist_table');
  Hive.openBox<TasksTable>('taskist_tasktable');
  Hive.openBox<Task>('taskist_task');
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
