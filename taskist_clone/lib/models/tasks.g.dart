// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasks.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskistAdapter extends TypeAdapter<Taskist> {
  @override
  final int typeId = 3;

  @override
  Taskist read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Taskist(
      tasksTable: (fields[0] as List).cast<TasksTable>(),
    );
  }

  @override
  void write(BinaryWriter writer, Taskist obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.tasksTable);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskistAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TasksTableAdapter extends TypeAdapter<TasksTable> {
  @override
  final int typeId = 1;

  @override
  TasksTable read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TasksTable(
      color: fields[0] as String,
      name: fields[1] as String,
      tasks: (fields[2] as List).cast<Task>(),
    );
  }

  @override
  void write(BinaryWriter writer, TasksTable obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.color)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.tasks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TasksTableAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 0;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      name: fields[0] as String,
      check: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.check);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
