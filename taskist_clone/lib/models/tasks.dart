import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'dart:convert';
part 'tasks.g.dart';

@HiveType(typeId: 3)
class Taskist extends HiveObject {
  Taskist({
    required this.tasksTable,
  });

  @HiveField(0)
  late List<TasksTable> tasksTable;

  factory Taskist.fromRawJson(String str) => Taskist.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Taskist.fromJson(Map<String, dynamic> json) {
    return Taskist(
      tasksTable: List<TasksTable>.from(
          json["TasksTable"].map((x) => TasksTable.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "TasksTable": List<dynamic>.from(tasksTable.map((x) => x.toJson())),
    };
  }
}

@HiveType(typeId: 1)
class TasksTable extends HiveObject {
  TasksTable({
    required this.color,
    required this.name,
    required this.tasks,
  });

  @HiveField(0)
  late String color;
  @HiveField(1)
  late String name;
  @HiveField(2)
  late List<Task> tasks;

  factory TasksTable.fromRawJson(String str) =>
      TasksTable.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TasksTable.fromJson(Map<String, dynamic> json) => TasksTable(
        color: json["color"],
        name: json["name"],
        tasks: List<Task>.from(json["tasks"].map((x) => Task.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "color": color,
        "name": name,
        "tasks": List<dynamic>.from(tasks.map((x) => x.toJson())),
      };
}

@HiveType(typeId: 0)
class Task extends HiveObject {
  Task({
    required this.name,
    required this.check,
  });

  @HiveField(0)
  late String name;
  @HiveField(1)
  late String check;

  factory Task.fromRawJson(String str) => Task.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      name: json["task"],
      check: json["check"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "task": name,
      "check": check,
    };
  }
}
