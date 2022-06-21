import 'dart:convert';

class TaskTables {
  TaskTables({required this.name, required this.color, this.id});

  final String name;
  final String color;
  final int? id;

  factory TaskTables.fromRawJson(String str) =>
      TaskTables.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TaskTables.fromJson(Map<String, dynamic> json) {
    return TaskTables(name: json["name"], color: json["color"], id: json["id"]);
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "color": color,
        "id": id,
      };
}

class Task {
  Task(
      {required this.name,
      required this.check_val,
      this.id,
      required this.taskTables_name});

  final int? id;
  final String name;
  final String check_val;
  final String taskTables_name;

  factory Task.fromRawJson(String str) => Task.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      name: json["name"],
      check_val: json["check_val"].toString(),
      taskTables_name: json["taskTables_name"],
      id: json["id"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "check_val": check_val,
      "taskTables_name": taskTables_name,
      "id": id
    };
  }
}
