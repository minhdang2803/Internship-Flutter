import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:todoist/database_helper.dart';
import '../models/models.dart';
import '../theme.dart';

class EdittingTasks extends StatefulWidget {
  const EdittingTasks({Key? key, required this.task}) : super(key: key);
  final TaskTables? task;
  @override
  State<EdittingTasks> createState() => _EdittingTasksState();
}

class _EdittingTasksState extends State<EdittingTasks> {
  late Color _color;
  late String _name;
  final _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _color = Color(int.parse(widget.task!.color));
      // _tasks = widget.task!.tasks;
      _name = widget.task!.name;
    } else {
      _color = Colors.blue;
      // _tasks = [];
      _name = 'task';
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: _color,
        onPressed: () => buildAddTasks(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void buildAddTasks(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Add Tasks',
          style: TaskistTheme.lightTextTheme.headline3!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SizedBox(
          height: MediaQuery.of(context).size.height * 0.11,
          child: Column(
            children: [
              buildTextField(),
              TextButton(
                child: Text('Add',
                    style: TaskistTheme.lightTextTheme.headline3!.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
                onPressed: () {
                  DatabaseHelper.instance.insertTask(
                      task: Task(
                        check_val: '0',
                        name: _controller.text,
                        taskTables_name: widget.task!.name,
                      ),
                      taskTables: widget.task!);
                  _controller.clear();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField() {
    return TextField(
      controller: _controller,
      decoration: const InputDecoration(),
    );
  }

  Widget buildSmallTasks(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.1,
            bottom: MediaQuery.of(context).size.width * 0.1),
        child: FutureBuilder(
          future: DatabaseHelper.instance.getTasks(widget.task),
          builder: (context, AsyncSnapshot<List<Task>> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                  child: Text('No tasks done',
                      style: TaskistTheme.lightTextTheme.headline2));
            } else if (snapshot.hasData) {
              return ListView.separated(
                  itemBuilder: (item, index) {
                    Task task = snapshot.data![index];
                    return Dismissible(
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        DatabaseHelper.instance.deleteCurrentTask(
                          task: task,
                          tasktable: widget.task!,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${task.name} dismissed',
                              style: TaskistTheme.lightTextTheme.headline3!
                                  .copyWith(color: _color),
                            ),
                          ),
                        );
                        setState(() {});
                      },
                      background: Container(
                        padding: const EdgeInsets.only(right: 10),
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        child: const Icon(
                          Icons.delete_forever,
                          color: Colors.white,
                          size: 30.0,
                        ),
                      ),
                      key: UniqueKey(),
                      child: GestureDetector(
                        child: smallTasks(task, task.check_val),
                        onTap: () {
                          DatabaseHelper.instance.updateCurrentTask(
                            tasktable: widget.task!,
                            task: task,
                            currentValue: task.check_val == '0' ? '1' : '0',
                          );
                          setState(() {});
                        },
                      ),
                    );
                  },
                  separatorBuilder: (item, index) => SizedBox(
                      height: MediaQuery.of(context).size.height * 0.015),
                  itemCount: snapshot.data!.length);
            } else if (snapshot.hasError) {
              return Center(
                  child: Text(snapshot.error.toString(),
                      style: TaskistTheme.lightTextTheme.headline2));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget smallTasks(Task task, String check) {
    int isDone = int.parse(check);
    return Row(
      children: [
        task.check_val == '0'
            ? const Icon(Icons.check_box_outline_blank)
            : const Icon(Icons.check_box),
        const SizedBox(width: 20),
        RichText(
          text: TextSpan(
            text: task.name,
            style: TaskistTheme.lightTextTheme.headline1!.copyWith(
                fontWeight: FontWeight.normal,
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
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildTitleOfTask(context),
          SizedBox(height: MediaQuery.of(context).size.height * 0.010),
          const Text("1 of 2 tasks"),
          SizedBox(height: MediaQuery.of(context).size.height * 0.010),
          Row(
            children: [
              Expanded(
                child: Container(
                  color: _color,
                  height: 8,
                ),
              ),
              const SizedBox(width: 5),
              const Text('50%'),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildTitleOfTask(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      leading: Text(_name,
          style: TaskistTheme.lightTextTheme.headline3!
              .copyWith(fontSize: 40, fontWeight: FontWeight.bold)),
      trailing: IconButton(
        padding: EdgeInsets.zero,
        icon: const Icon(Icons.delete, size: 40),
        onPressed: () {
          //TODO: Delete TaskTable
          DatabaseHelper.instance.deleteItem(widget.task!);
          Navigator.pop(context, true);
        },
      ),
    );
  }

  Widget buildTopBar(context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.0),
      child: ListTile(
        leading: IconButton(
          icon: Icon(
            Icons.circle,
            size: 40,
            color: _color,
          ),
          onPressed: () => pickColor(context),
        ),
        trailing: IconButton(
          onPressed: () => Navigator.pop(context, true),
          icon: const Icon(Icons.clear, size: 30),
        ),
      ),
    );
  }

  void pickColor(BuildContext context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Pick Your Color',
            style: TaskistTheme.lightTextTheme.headline3!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.46,
            child: Column(
              children: [
                buildColorPicker(),
                TextButton(
                  child: Text('Select this',
                      style: TaskistTheme.lightTextTheme.headline3!.copyWith(
                        fontWeight: FontWeight.bold,
                      )),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
      );
  Widget buildColorPicker() => BlockPicker(
        pickerColor: Color(int.parse(widget.task!.color)),
        onColorChanged: (color) => setState(() => _color = color),
      );
}
//widget.task == null ? _color :