import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../models/models.dart';
import '../theme.dart';

class EdittingTasks extends StatefulWidget {
  const EdittingTasks({Key? key, this.task}) : super(key: key);
  final TasksTable? task;
  @override
  State<EdittingTasks> createState() => _EdittingTasksState();
}

class _EdittingTasksState extends State<EdittingTasks> {
  late Color _color;
  late List<Task> _tasks;
  late String _name;
  final _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _color = Color(int.parse(widget.task!.color));
      _tasks = widget.task!.tasks;
      _name = widget.task!.name;
    } else {
      _color = Colors.blue;
      _tasks = [];
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
                onPressed: () => Navigator.of(context).pop(),
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
        child: ListView.separated(
            itemBuilder: (item, index) => smallTasks(),
            separatorBuilder: (item, index) =>
                SizedBox(height: MediaQuery.of(context).size.height * 0.015),
            itemCount: 50),
      ),
    );
  }

  Widget smallTasks() {
    return Row(
      children: [
        const Icon(Icons.check_box),
        const SizedBox(width: 20),
        Text(
          'Hello world',
          style: TaskistTheme.lightTextTheme.headline1!
              .copyWith(fontWeight: FontWeight.normal),
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
          //TODO: Delete task in database
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
        pickerColor:
            widget.task == null ? _color : Color(int.parse(widget.task!.color)),
        onColorChanged: (color) => setState(() => _color = color),
      );
}
