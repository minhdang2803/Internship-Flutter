import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:todoist/database_helper.dart';
import 'package:todoist/error_handler.dart';
import 'package:todoist/models/models.dart';
import 'package:todoist/providers/providers.dart';

class AddingTasks extends StatefulWidget {
  const AddingTasks({Key? key}) : super(key: key);

  @override
  State<AddingTasks> createState() => _AddingTasksState();
}

class _AddingTasksState extends State<AddingTasks> {
  final _controller = TextEditingController();
  Color _color = Colors.blue.shade300;
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        title: Text(
          'New List',
          style: Theme.of(context).textTheme.headline2,
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextTitle(),
              const SizedBox(height: 20),
              buildTextField(),
              const SizedBox(height: 20),
              buildChooseColor(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // try {
          //   Provider.of<TaskManager>(context, listen: false)
          //       .insertTaskTable(TaskTables(
          //     all_done: 0,
          //     color: _color.value.toString(),
          //     name: _controller.text,
          //   ));
          // } catch (error) {
          //   String getError = ErrorHandler.getError(error.toString());
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(
          //       content: Text(
          //         'Table of tasks$getError',
          //         style: Theme.of(context)
          //             .textTheme
          //             .headline3!
          //             .copyWith(color: _color),
          //       ),
          //     ),
          //   );
          // }
          Provider.of<TaskManager>(context, listen: false)
              .insertTaskTable(TaskTables(
            all_done: 0,
            color: _color.value.toString(),
            name: _controller.text,
          ));
          _controller.clear();
          Navigator.pop(context, true);
        },
        label: const Text('Create Task'),
        icon: const Icon(Icons.add),
        backgroundColor: _color,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget buildTextTitle() {
    return Text(
      'Add the name of your list 🚀',
      style:
          Theme.of(context).textTheme.headline3!.copyWith(color: Colors.grey),
    );
  }

  Widget buildTextField() {
    return TextField(
      cursorColor: _color,
      controller: _controller,
      decoration: InputDecoration(
        hintText: 'Your List...',
        border: InputBorder.none,
        hintStyle: Theme.of(context).textTheme.headline1!.copyWith(
              color: Colors.grey,
            ),
      ),
      style:
          TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: _color),
      autofocus: true,
    );
  }

  Widget buildChooseColor(context) {
    return IconButton(
      padding: EdgeInsets.zero,
      iconSize: 20,
      onPressed: () => pickColor(context),
      icon: Icon(
        Icons.circle,
        color: _color,
        size: 50,
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
                  child: Text(
                    'Select this',
                    style: Theme.of(context).textTheme.headline3!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ),
      );
  Widget buildColorPicker() => BlockPicker(
      pickerColor: _color,
      onColorChanged: (color) => setState(() => _color = color));
}
