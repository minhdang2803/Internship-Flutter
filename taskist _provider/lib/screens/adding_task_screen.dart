import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:todoist/error_handler.dart';
import 'package:todoist/models/models.dart';
import 'package:todoist/providers/providers.dart';

class AddingTasks extends StatelessWidget {
  final _controller = TextEditingController();

  AddingTasks({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskManager(),
      child: Consumer<TaskManager>(
        builder: (context, taskManager, child) => Scaffold(
          appBar: buildAppBar(context),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextTitle(context),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                  buildTextField(context),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                  buildChooseColor(context, taskManager),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              bool isError = false;
              try {
                await taskManager.insertTaskTable(TaskTables(
                  all_done: 0,
                  color: taskManager.getColor.value.toString(),
                  name: _controller.text,
                ));
              } catch (error) {
                String getError = ErrorHandler.getError(error.toString());
                await showError(context, getError, taskManager.getColor);
                isError = true;
              }
              _controller.clear();
              !isError ? Navigator.pop(context, true) : null;
            },
            label: const Text('Create Task'),
            icon: const Icon(Icons.add),
            backgroundColor: taskManager.getColor,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      titleSpacing: 0,
      title: Text(
        'New List',
        style: Theme.of(context).textTheme.headline2,
        textAlign: TextAlign.center,
      ),
      backgroundColor: Colors.transparent,
    );
  }

  Future<void> showError(
      BuildContext context, String error, Color color) async {
    await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title:
            Text('Clm error nek', style: Theme.of(context).textTheme.headline3),
        content: Text('Task Table$error',
            style: Theme.of(context).textTheme.headline3),
        actions: [
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(color)),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget buildTextTitle(context) {
    return Text(
      'Add the name of your list 🚀',
      style:
          Theme.of(context).textTheme.headline3!.copyWith(color: Colors.grey),
    );
  }

  Widget buildTextField(context) {
    return TextField(
      cursorColor: Provider.of<TaskManager>(context, listen: false).getColor,
      controller: _controller,
      decoration: InputDecoration(
        hintText: 'Your List...',
        border: InputBorder.none,
        hintStyle: Theme.of(context).textTheme.headline1!.copyWith(
              color: Colors.grey,
            ),
      ),
      style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Provider.of<TaskManager>(context, listen: false).getColor),
      autofocus: true,
    );
  }

  Widget buildChooseColor(context, TaskManager taskManager) {
    return IconButton(
      padding: EdgeInsets.zero,
      iconSize: 20,
      onPressed: () => pickColor(context, taskManager),
      icon: Icon(
        Icons.circle,
        color: taskManager.getColor,
        size: 50,
      ),
    );
  }

  void pickColor(BuildContext context, TaskManager taskManager) {
    showDialog(
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
              buildColorPicker(context, taskManager),
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
  }

  Widget buildColorPicker(BuildContext context, TaskManager taskManager) {
    return BlockPicker(
      pickerColor: taskManager.getColor,
      onColorChanged: (color) => taskManager.setColor(color),
    );
  }
}
