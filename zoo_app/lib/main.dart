import 'package:demo_firstapp/theme.dart';
import 'package:flutter/material.dart';
import './screens/homepage.dart';

void main() => runApp(const ZooApp());

class ZooApp extends StatefulWidget {
  const ZooApp({Key? key}) : super(key: key);

  @override
  State<ZooApp> createState() => _ZooAppState();
}

class _ZooAppState extends State<ZooApp> {
  ThemeData theme = ZooTheme.light();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      title: 'The Zoo',
      home: const HomePage(),
    );
  }
}
