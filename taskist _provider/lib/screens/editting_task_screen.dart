import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:todoist/database_helper.dart';
import 'package:todoist/error_handler.dart';
import '../models/models.dart';

class EdittingTasks extends StatefulWidget {
  const EdittingTasks({Key? key, required this.task}) : super(key: key);
  final TaskTables? task;
  @override
  State<EdittingTasks> createState() => _EdittingTasksState();
}

class _EdittingTasksState extends State<EdittingTasks> {
  late String? _error;
  late Color _color;
  late String _name;
  double _ratio = 0;
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
    _error = null;
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
        onPressed: () {
          buildAddTasks(context);
          setState(() {});
        },
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
          style: Theme.of(context).textTheme.headline3!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        content: SingleChildScrollView(
          child: Column(
            children: [
              buildTextField(),
              TextButton(
                child: Text('Add',
                    style: Theme.of(context).textTheme.headline3!.copyWith(
                          fontWeight: FontWeight.bold,
                        )),
                onPressed: () async {
                  try {
                    await DatabaseHelper.instance.insertTask(
                        task: Task(
                          check_val: '0',
                          name: _controller.text,
                          taskTables_name: widget.task!.name,
                        ),
                        taskTables: widget.task!);
                    _controller.clear();
                    await DatabaseHelper.instance
                        .setDone(tasktable: widget.task!);
                    _ratio =
                        await DatabaseHelper.instance.countDone(widget.task!);
                  } catch (error) {
                    print(error.toString());
                    _error = error.toString();
                    String getError = ErrorHandler.getError(_error!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor:
                            Theme.of(context).colorScheme.primary,
                        content: Text('Task$getError',
                            style: Theme.of(context)
                                .textTheme
                                .headline3!
                                .copyWith(color: _color)),
                      ),
                    );
                  }
                  // setState(() {});
                  Navigator.pop(context, true);
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
            if (snapshot.hasData) {
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
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            content: Text(
                              '${task.name} dismissed',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3!
                                  .copyWith(color: _color),
                            ),
                          ),
                        );
                        DatabaseHelper.instance
                            .setDone(tasktable: widget.task!);
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
                        onTap: () async {
                          DatabaseHelper.instance.updateCurrentTask(
                            tasktable: widget.task!,
                            task: task,
                            currentValue: task.check_val == '0' ? '1' : '0',
                          );
                          DatabaseHelper.instance
                              .setDone(tasktable: widget.task!);
                          _ratio = await DatabaseHelper.instance
                              .countDone(widget.task!);
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
                      style: Theme.of(context).textTheme.headline2));
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
            style: Theme.of(context).textTheme.headline1!.copyWith(
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
          Text("${(_ratio * 100).toInt()}% of tasks"),
          SizedBox(height: MediaQuery.of(context).size.height * 0.010),
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  color: _color,
                  value: _ratio,
                  backgroundColor: _color.withOpacity(0.2),
                ),
              ),
              const SizedBox(width: 5),
              Text('${(_ratio * 100).toInt()}%'),
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
          padding: EdgeInsets.zero,
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
            style: Theme.of(context).textTheme.headline3!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                buildColorPicker(),
                TextButton(
                  child: Text('Select this',
                      style: Theme.of(context).textTheme.headline3!.copyWith(
                            fontWeight: FontWeight.bold,
                          )),
                  onPressed: () {
                    DatabaseHelper.instance
                        .setColor(taskTables: widget.task!, color: _color);
                    Navigator.pop(context, true);
                  },
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