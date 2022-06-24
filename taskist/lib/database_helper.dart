import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:todoist/models/models.dart';
import 'package:flutter/material.dart';

class DatabaseHelper {
  static const _databaseName = 'taskist.db';
  static const _databaseVersion = 1;
  static const _taskTable = 'TaskTables';
  static const _task = 'Tasks';
  static Database? _database;

  //Singleton Pattern

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    return _database ?? await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    String path = await getDatabasesPath();
    String dbPath = join(path, _databaseName);
    return await openDatabase(
      dbPath,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
        CREATE TABLE $_taskTable(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT UNIQUE,
          color TEXT,
          all_done TEXT
        );
''');
    await db.execute("""
        CREATE TABLE $_task(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT UNIQUE,
          check_val INTEGER NOT NULL CHECK(check_val >=0 AND check_val <=1),
          taskTables_name TEXT, 
          FOREIGN KEY(TaskTables_name) REFERENCES $_taskTable(name)
        );
""");
  }

  Future<List<TaskTables>> getTaskTables() async {
    final db = await instance.database;
    final tasktables = await db.query(_taskTable,
        columns: ['id', 'name', 'color', 'all_done'],
        where: 'all_done = ?',
        whereArgs: [0]);
    List<TaskTables> ret = tasktables.isNotEmpty
        ? tasktables.map((task) => TaskTables.fromJson(task)).toList()
        : [];
    return ret;
  }

  Future<int> insertTaskTable(TaskTables taskTable) async {
    final db = await instance.database;
    return await db.insert(
      _taskTable,
      taskTable.toJson(),
    );
  }

  Future<int> deleteItem(TaskTables task) async {
    deleteTask(task);
    final db = await instance.database;
    return await db.delete(_taskTable, where: "id = ?", whereArgs: [task.id]);
  }

  Future<List<Task>> getTasks(TaskTables? task) async {
    final db = await instance.database;
    late List<Map<String, Object?>> taskTable;
    if (task != null) {
      taskTable = await db.rawQuery('''
    SELECT $_task.id, $_task.check_val, $_task.name, $_task.taskTables_name
    FROM $_task 
    INNER JOIN $_taskTable 
    ON $_task.taskTables_name = $_taskTable.name
    WHERE $_task.taskTables_name = '${task.name}';
''');
    } else {
      return [];
    }
    List<Task> ret = taskTable.isNotEmpty
        ? taskTable.map((element) => Task.fromJson(element)).toList()
        : [];
    return ret;
  }

  Future<int> setDone({required TaskTables tasktable}) async {
    final db = await instance.database;
    List<Task> listTasks = await getTasks(tasktable);
    bool isDone = listTasks.every((element) => element.check_val == '1');
    if (isDone && listTasks.isNotEmpty) {
      return db.rawUpdate('''
      UPDATE $_taskTable
      SET all_done = '1'
      WHERE $_taskTable.name = '${tasktable.name}'
''');
    } else {
      return db.rawUpdate('''
      UPDATE $_taskTable
      SET all_done = '0'
      WHERE $_taskTable.name = '${tasktable.name}'
''');
    }
  }

  Future<int> insertTask(
      {required Task task, required TaskTables taskTables}) async {
    final db = await instance.database;
    return await db.rawInsert('''
    INSERT INTO $_task(name, check_val, taskTables_name) 
    VALUES("${task.name}", "${task.check_val}", "${task.taskTables_name}");
''');
  }

  Future<int> deleteTask(TaskTables task) async {
    final db = await instance.database;
    return await db.rawDelete('''
    DELETE FROM $_task 
    WHERE $_task.taskTables_name = "${task.name}";
''');
  }

  Future<int> deleteCurrentTask(
      {required TaskTables tasktable, required Task task}) async {
    final db = await instance.database;
    return await db.rawDelete('''
    DELETE FROM $_task 
    WHERE $_task.taskTables_name = "${tasktable.name}" AND $_task.name = "${task.name}";
''');
  }

  Future<int> updateCurrentTask(
      {required TaskTables tasktable,
      required Task task,
      required String currentValue}) async {
    final db = await instance.database;
    return await db.rawUpdate('''
    UPDATE $_task
    SET check_val = "$currentValue"
    WHERE taskTables_name = "${tasktable.name}" AND name = "${task.name}";
''');
  }

  Future<void> deleteAllTable() async {
    final db = await instance.database;
    await db.rawDelete('''
    DELETE FROM $_taskTable;
''');
  }

  Future<void> deleteAllTask() async {
    final db = await instance.database;
    await db.rawDelete('''
    DELETE FROM $_task;
''');
  }

  Future<List<TaskTables>> getAllDone() async {
    final db = await instance.database;
    final taskTable = await db.rawQuery('''
    SELECT * FROM $_taskTable WHERE all_done = 1;
''');
    List<TaskTables> ret = taskTable.isNotEmpty
        ? taskTable.map((e) => TaskTables.fromJson(e)).toList()
        : [];
    return ret;
  }

  Future<int> setColor(
      {required TaskTables taskTables, required Color color}) async {
    final db = await instance.database;
    return db.rawUpdate('''
    UPDATE $_taskTable
    SET color = ${color.value}
    WHERE $_taskTable.name = '${taskTables.name}';
''');
  }

  Future<double> countDone(TaskTables taskTables) async {
    int count = 0;
    List<Task> listTasks = await getTasks(taskTables);
    listTasks.forEach((element) {
      if (element.check_val == '1') {
        count++;
      }
    });
    return (count / listTasks.length).toDouble();
  }

  Future close() async {
    final db = await instance.database;
    return db.close();
  }
}
