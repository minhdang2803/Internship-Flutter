import 'package:hive/hive.dart';
import 'package:todoist/models/models.dart';

class Boxes {
  static Box<TasksTable> getTaskTables() =>
      Hive.box<TasksTable>('taskist_tasktable');
}
