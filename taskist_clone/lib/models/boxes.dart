import 'package:hive/hive.dart';
import 'package:todoist/models/models.dart';

class Boxes {
  static Box<TaskTables> getTaskTables() =>
      Hive.box<TaskTables>('taskist_tasktable');
}
