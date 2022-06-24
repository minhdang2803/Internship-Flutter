import 'dart:convert';

class TaskTables {
  TaskTables(
      {required this.name,
      required this.color,
      this.id,
      // ignore: non_constant_identifier_names
      required this.all_done});

  final String name;
  final String color;
  final int? id;
  // ignore: non_constant_identifier_names
  final int all_done;

  factory TaskTables.fromRawJson(String str) =>
      TaskTables.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TaskTables.fromJson(Map<String, dynamic> json) {
    return TaskTables(
        name: json["name"],
        color: json["color"],
        id: json["id"],
        all_done: int.parse(json["all_done"]));
  }

  Map<String, dynamic> toJson() =>
      {"name": name, "color": color, "id": id, "all_done": all_done};
}

class Task {
  Task(
      {required this.name,
      // ignore: non_constant_identifier_names
      required this.check_val,
      this.id,
      // ignore: non_constant_identifier_names
      required this.taskTables_name});

  final int? id;
  final String name;
  // ignore: non_constant_identifier_names
  final String check_val;
  // ignore: non_constant_identifier_names
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
