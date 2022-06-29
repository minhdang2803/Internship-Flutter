import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:todoist/error_handler.dart';
import 'package:todoist/utils/utils_functions.dart';
import '../models/models.dart';
import '../providers/providers.dart';

class EdittingTasks extends StatelessWidget {
  EdittingTasks({Key? key, required this.taskTable}) : super(key: key);
  final TaskTables taskTable;
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.025),
              buildTopBar(context),
              SizedBox(height: MediaQuery.of(context).size.height * 0.025),
              buildTitle(context),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              buildSmallTasks(context),
            ],
          ),
        ),
      ),
      floatingActionButton: buildFloatingActionButton(context),
    );
  }

  Widget buildFloatingActionButton(BuildContext context) {
    return Consumer<TaskManager>(builder: (context, taskManager, child) {
      return FloatingActionButton(
        backgroundColor: taskManager.getEditingColor,
        onPressed: () {
          buildAddTasks(context, taskManager);
          _controller.clear();
        },
        child: const Icon(Icons.add),
      );
    });
  }

  void buildAddTasks(BuildContext context, TaskManager taskManager) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Add Tasks',
          style: Theme.of(context)
              .textTheme
              .headline3!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            children: [
              buildTextField(context, taskManager),
              TextButton(
                child: Text('Add',
                    style: Theme.of(context)
                        .textTheme
                        .headline3!
                        .copyWith(fontWeight: FontWeight.bold)),
                onPressed: () async {
                  try {
                    await taskManager.insertTask(
                        task: Task(
                          check_val: '0',
                          name: _controller.text,
                          taskTables_name: taskTable.name,
                        ),
                        taskTables: taskTable);
                    _controller.clear();
                    await taskManager.setDone(tasktable: taskTable);
                    taskManager.updateRatio(taskTable);
                  } catch (error) {
                    String getError = ErrorHandler.getError(error.toString());
                    buildErrorSnackBar(context, 'Task $getError', taskManager);
                  }
                  Navigator.pop(context, true);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(BuildContext context, TaskManager taskManager) {
    return TextField(
      controller: _controller,
      decoration: const InputDecoration(),
    );
  }

  Widget buildSmallTasks(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.05,
          bottom: MediaQuery.of(context).size.width * 0.05,
          right: MediaQuery.of(context).size.width * 0.05,
        ),
        child: Consumer<TaskManager>(builder: (context, taskManager, child) {
          return FutureBuilder(
            future: taskManager.getTasks(taskTable),
            builder: (context, AsyncSnapshot<List<Task>> snapshot) {
              if (snapshot.hasData) {
                return ListView.separated(
                    itemBuilder: (item, index) {
                      Task task = snapshot.data![index];
                      return GestureDetector(
                        onTap: () {
                          taskManager.updateCurrentTask(
                            tasktable: taskTable,
                            task: task,
                            currentValue: task.check_val == '0' ? '1' : '0',
                          );
                          taskManager.setDone(tasktable: taskTable);
                          taskManager.updateRatio(taskTable);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            smallTasks(
                                context, task, task.check_val, taskManager),
                            IconButton(
                                onPressed: () {
                                  taskManager.deleteCurrentTask(
                                      tasktable: taskTable, task: task);
                                  taskManager.setDone(tasktable: taskTable);
                                  taskManager.updateRatio(taskTable);
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: taskManager.getEditingColor,
                                ))
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (item, index) => SizedBox(
                        height: MediaQuery.of(context).size.height * 0.015),
                    itemCount: snapshot.data!.length);
              } else if (snapshot.hasError) {
                return Center(
                    child: Text(snapshot.error.toString(),
                        style: Theme.of(context).textTheme.headline2));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          );
        }),
      ),
    );
  }

  Widget smallTasks(
      BuildContext context, Task task, String check, TaskManager taskManager) {
    int isDone = int.parse(check);
    Color color = taskManager.getEditingColor;
    return Row(
      children: [
        task.check_val == '0'
            ? Icon(Icons.check_box_outline_blank, color: color)
            : Icon(Icons.check_box, color: color),
        const SizedBox(width: 20),
        RichText(
          text: TextSpan(
            text: task.name,
            style: Theme.of(context).textTheme.headline2!.copyWith(
                decorationColor: color,
                fontWeight: FontWeight.w200,
                decoration: isDone == 1
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                decorationThickness: 3),
          ),
        )
      ],
    );
  }

  Widget buildTitle(BuildContext context) {
    return Consumer<TaskManager>(
      builder: (context, taskManager, child) {
        return Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildTitleOfTask(context, taskManager),
              SizedBox(height: MediaQuery.of(context).size.height * 0.010),
              Text("${(taskManager.getEditingRatio * 100).toInt()}% of tasks"),
              SizedBox(height: MediaQuery.of(context).size.height * 0.010),
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      color: taskManager.getEditingColor,
                      value: taskManager.getEditingRatio,
                      backgroundColor:
                          taskManager.getEditingColor.withOpacity(0.2),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text('${(taskManager.getEditingRatio * 100).toInt()}%'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildTitleOfTask(BuildContext context, TaskManager taskManager) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      leading: Text(taskTable.name,
          style: Theme.of(context)
              .textTheme
              .headline3!
              .copyWith(fontSize: 40, fontWeight: FontWeight.bold)),
      trailing: IconButton(
        padding: EdgeInsets.zero,
        icon: const Icon(Icons.delete, size: 40),
        onPressed: () {
          // ignore: todo
          //TODO: Delete TaskTable
          taskManager.deleteItem(taskTable);
          Navigator.pop(context, true);
        },
      ),
    );
  }

  Widget buildTopBar(BuildContext context) {
    return Consumer<TaskManager>(builder: (context, taskManager, child) {
      return Container(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.0),
        child: ListTile(
          leading: IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(
              Icons.circle,
              size: 40,
              color: taskManager.getEditingColor,
            ),
            onPressed: () => pickColor(context, taskManager),
          ),
          trailing: IconButton(
            onPressed: () {
              _controller.dispose();
              Navigator.pop(context, true);
            },
            icon: const Icon(Icons.clear, size: 30),
          ),
        ),
      );
    });
  }

  void pickColor(BuildContext context, TaskManager taskManager) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Pick Your Color',
            style: Theme.of(context)
                .textTheme
                .headline3!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                buildColorPicker(taskManager),
                TextButton(
                  child: Text(
                    'Select this',
                    style: Theme.of(context)
                        .textTheme
                        .headline3!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    taskManager.setTaskColor(
                        taskTables: taskTable,
                        color: taskManager.getEditingColor);
                    Navigator.pop(context, true);
                  },
                ),
              ],
            ),
          ),
        ),
      );

  Widget buildColorPicker(TaskManager taskManager) => BlockPicker(
        pickerColor: taskManager.getEditingColor,
        onColorChanged: (color) => taskManager.setColor(color, false),
      );
}
//task == null ? _color :z