import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoist/utils/database_helper.dart';
import '../models/models.dart';

class TaskManager extends ChangeNotifier {
  //Bottom bavigation bar
  DateTime _dateTime = DateTime.now();
  DateTime get getDateTime => _dateTime;
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

  // Adding task screeen
  Color _addingTaskColor = Colors.blue.shade300;
  Color get getAddingTaskColor => _addingTaskColor;

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

  void setColor(Color color, bool isAdd) {
    isAdd ? _addingTaskColor = color : _editingTaskColor = color;
    notifyListeners();
  }

  Future<void> showError(
      BuildContext context, String error, Color color) async {
    await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title:
            Text('Clm error nek', style: Theme.of(context).textTheme.headline3),
        content: Text('Task Table$error',
            style: Theme.of(context).textTheme.headline3),
        actions: [
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(color)),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
    // notifyListeners();
  }

  // Editting task screeen
  String? _editingTaskError = null;
  Color _editingTaskColor = Colors.blue.shade300;
  String _editingTaskName = 'task';
  double _editingTaskRatio = 0;

  String? get getEditingTaskError => _editingTaskError;
  String get getEditingTaskName => _editingTaskName;
  Color get getEditingColor => _editingTaskColor;
  Future<void> updateRatio(TaskTables taskTables) async {
    _editingTaskRatio = await countDone(taskTables);
    notifyListeners();
  }

  double get getEditingRatio => _editingTaskRatio;

  Future<void> setEachTaskTable(TaskTables tasktable) async {
    _editingTaskColor = Color(int.parse(tasktable.color));
    _editingTaskName = tasktable.name;
    _editingTaskRatio = await countDone(tasktable);
    _editingTaskError = null;
    notifyListeners();
  }

  void resetEachTaskTable() {
    _editingTaskColor = Colors.blue.shade300;
    _editingTaskName = 'task';
    _editingTaskRatio = 0;
    _editingTaskError = null;
  }

  void setError(String error) {
    _editingTaskError = error;
    // notifyListeners();
  }

  Future<List<Task>> getTasks(TaskTables? task) async {
    _database = await DatabaseHelper.instance.database;
    late List<Map<String, Object?>> taskTable;
    if (task != null) {
      taskTable = await _database.rawQuery('''
    SELECT $_task.id, $_task.check_val, $_task.name, $_task.taskTables_name
    FROM $_task 
    WHERE $_task.taskTables_name = '${task.name}';
''');
    } else {
      return [];
    }
    List<Task> ret = taskTable.isNotEmpty
        ? taskTable.map((element) => Task.fromJson(element)).toList()
        : [];
    notifyListeners();
    return ret;
  }

  Future<double> countDone(TaskTables taskTables) async {
    int count = 0;
    List<Task> listTasks = await getTasks(taskTables);
    listTasks.forEach((element) {
      if (element.check_val == '1') {
        count++;
      }
    });
    if (count == 0) {
      notifyListeners();
      return 0;
    } else {
      notifyListeners();
      return (count / listTasks.length).toDouble();
    }
  }

  Future<int> updateCurrentTask(
      {required TaskTables tasktable,
      required Task task,
      required String currentValue}) async {
    _database = await DatabaseHelper.instance.database;
    final db = await _database.rawUpdate('''
    UPDATE $_task
    SET check_val = "$currentValue"
    WHERE taskTables_name = "${tasktable.name}" AND name = "${task.name}";
''');
    notifyListeners();
    return db;
  }

  Future<int> insertTask(
      {required Task task, required TaskTables taskTables}) async {
    _database = await DatabaseHelper.instance.database;
    notifyListeners();
    return await _database.rawInsert('''
    INSERT INTO $_task(name, check_val, taskTables_name) 
    VALUES("${task.name}", "${task.check_val}", "${task.taskTables_name}");
''');
  }

  Future<int> setDone({required TaskTables tasktable}) async {
    _database = await DatabaseHelper.instance.database;
    List<Task> listTasks = await getTasks(tasktable);
    bool isDone = listTasks.every((element) => element.check_val == '1');
    if (isDone && listTasks.isNotEmpty) {
      notifyListeners();
      return await _database.rawUpdate('''
      UPDATE $_taskTable
      SET all_done = '1'
      WHERE $_taskTable.name = '${tasktable.name}'
''');
    } else {
      notifyListeners();
      return await _database.rawUpdate('''
      UPDATE $_taskTable
      SET all_done = '0'
      WHERE $_taskTable.name = '${tasktable.name}'
''');
    }
  }

  Future<int> setTaskColor(
      {required TaskTables taskTables, required Color color}) async {
    _database = await DatabaseHelper.instance.database;
    final db = await _database.rawUpdate('''
    UPDATE $_taskTable
    SET color = ${color.value}
    WHERE $_taskTable.name = '${taskTables.name}';
''');
    notifyListeners();
    return db;
  }

  Future<int> deleteCurrentTask(
      {required TaskTables tasktable, required Task task}) async {
    _database = await DatabaseHelper.instance.database;
    notifyListeners();
    return await _database.rawDelete('''
    DELETE FROM $_task 
    WHERE $_task.taskTables_name = "${tasktable.name}" AND $_task.name = "${task.name}";
''');
  }

  Future<int> deleteItem(TaskTables task) async {
    await deleteTask(task);
    _database = await DatabaseHelper.instance.database;
    // notifyListeners();
    return await _database
        .delete(_taskTable, where: "id = ?", whereArgs: [task.id]);
  }

  Future<int> deleteTask(TaskTables task) async {
    _database = await DatabaseHelper.instance.database;
    // notifyListeners();
    return await _database.rawDelete('''
    DELETE FROM $_task 
    WHERE $_task.taskTables_name = "${task.name}";
''');
  }

  Future<void> deleteAllTable() async {
    _database = await DatabaseHelper.instance.database;
    await _database.rawDelete('''
    DELETE FROM $_taskTable;
''');
  }

  Future<void> deleteAllTask() async {
    _database = await DatabaseHelper.instance.database;
    await _database.rawDelete('''
    DELETE FROM $_task;
''');
  }

  Future<List<TaskTables>> getAllDone() async {
    _database = await DatabaseHelper.instance.database;
    final taskTable = await _database.rawQuery('''
    SELECT * FROM $_taskTable WHERE all_done = 1;
''');
    List<TaskTables> ret = taskTable.isNotEmpty
        ? taskTable.map((e) => TaskTables.fromJson(e)).toList()
        : [];
    notifyListeners();
    return ret;
  }
}
