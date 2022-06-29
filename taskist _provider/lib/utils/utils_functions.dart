import 'package:flutter/material.dart';
import 'package:todoist/providers/providers.dart';
import '../models/models.dart';

void buildDissmessedSnackBar(
    BuildContext context, Task task, TaskManager taskManager) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      content: Text(
        '${task.name} dismissed',
        style: Theme.of(context)
            .textTheme
            .headline3!
            .copyWith(color: taskManager.getEditingColor),
      ),
    ),
  );
}

void buildErrorSnackBar(
    BuildContext context, String getError, TaskManager taskManager) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Theme.of(context).colorScheme.primary,
    content: Text(getError,
        style: Theme.of(context)
            .textTheme
            .headline3!
            .copyWith(color: taskManager.getEditingColor)),
  ));
}
