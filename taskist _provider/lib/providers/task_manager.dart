import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoist/database_helper.dart';

import '../models/models.dart';

class TaskManager extends ChangeNotifier {
  //Bottom bavigation bar
  int _currentTab = 1;
  int get getCurrentTab => _currentTab;
  void gotoTab(int index) {
    _currentTab = index;
    notifyListeners();
  }

  //Database
  late Database _database;
  static const _taskTable = 'TaskTables';
  static const _task = 'Tasks';
  Color _color = Colors.blue.shade300;
  Color get getColor => _color;
  Future<void> initDatabase() async {
    _database = await DatabaseHelper.instance.database;
  }

  Future<List<TaskTables>> getTaskTables() async {
    _database = await DatabaseHelper.instance.database;
    // await initDatabase();
    final tasktables = await _database.query(_taskTable,
        columns: ['id', 'name', 'color', 'all_done'],
        where: 'all_done = ?',
        whereArgs: [0]);
    List<TaskTables> ret = tasktables.isNotEmpty
        ? tasktables.map((task) => TaskTables.fromJson(task)).toList()
        : [];
    notifyListeners();
    return ret;
  }

  Future<int> insertTaskTable(TaskTables taskTable) async {
    _database = await DatabaseHelper.instance.database;
    final db = await _database.insert(
      _taskTable,
      taskTable.toJson(),
    );
    notifyListeners();
    return db;
  }

  void setColor(Color color) {
    _color = color;
    notifyListeners();
  }

  void showSnackBar(BuildContext context, String content, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Table of tasks$content',
          style: Theme.of(context).textTheme.headline3!.copyWith(color: color),
        ),
      ),
    );
    notifyListeners();
  }
}
