import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoist/database_helper.dart';
import 'package:todoist/theme.dart';
import 'screens/screens.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) =>
                TaskistThemeProvider(isDarkMode: prefs.getBool('isDarkTheme')?? false))
      ],
      child: const TaskistClone(),
    ),
  );
}

class TaskistClone extends StatefulWidget {
  const TaskistClone({Key? key}) : super(key: key);

  @override
  State<TaskistClone> createState() => _TaskistCloneState();
}

class _TaskistCloneState extends State<TaskistClone> {
  @override
  void dispose() {
    super.dispose();
    DatabaseHelper.instance.close();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskistThemeProvider>(
      builder: (context, value, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: value.getTheme,
          title: "Taskist Clone",
          home: const Homepage(),
        );
      },
    );
  }
}
