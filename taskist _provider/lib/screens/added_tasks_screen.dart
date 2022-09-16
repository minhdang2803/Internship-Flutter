import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todoist/components/components.dart';
import 'package:todoist/models/models.dart';
import 'package:todoist/providers/providers.dart';
import 'screens.dart';

class AddedTasks extends StatelessWidget {
  const AddedTasks({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            buildDateTime(),
            const SizedBox(height: 20),
            buildVerticalLine(context),
            const SizedBox(height: 30),
            buildAddTaskButton(context),
            const SizedBox(height: 40),
            Expanded(child: buildTasksList(context)),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.20,
            )
          ],
        ),
      ),
    );
  }

  Widget buildDateTime() {
    return Consumer<TaskManager>(builder: (context, taskManager, child) {
      String dateOfWeek = DateFormat('EEEE').format(taskManager.getDateTime);
      String date = DateFormat('d MMM').format(taskManager.getDateTime);
      return Container(
        padding: const EdgeInsets.only(left: 35, right: 35, top: 20),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(dateOfWeek, style: Theme.of(context).textTheme.headline2),
            Text(date, style: Theme.of(context).textTheme.headline2),
          ],
        ),
      );
    });
  }

  Widget buildVerticalLine(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Flexible(
          child: Divider(
            color: Theme.of(context).colorScheme.primary,
            thickness: 2,
          ),
        ),
        const SizedBox(width: 50),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: "Task",
                  style: Theme.of(context).textTheme.headline2?.copyWith(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      )),
              TextSpan(
                text: "Lists",
                style: Theme.of(context).textTheme.headline3?.copyWith(
                    fontSize: 30,
                    color: Colors.grey,
                    fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ),
        const SizedBox(width: 50),
        Flexible(
          child: Divider(
              color: Theme.of(context).colorScheme.primary, thickness: 2),
        ),
      ],
    );
  }

  Widget buildAddTaskButton(context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: Theme.of(context).colorScheme.primary, width: 2.0),
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddingTasks()),
            ),
            icon: const Icon(Icons.add, size: 30),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Add List',
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500),
        )
      ],
    );
  }

  Widget buildTasksList(context) {
    return Consumer<TaskManager>(builder: (context, taskManager, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: FutureBuilder(
          future: taskManager.getTaskTables(),
          builder: (context, AsyncSnapshot<List<TaskTables>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return Center(
                  child: Text('No tasks remain!',
                      style: Theme.of(context).textTheme.headline3),
                );
              } else {
                return buildListOfTasksTable(context, snapshot, taskManager);
              }
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString(),
                    style: Theme.of(context).textTheme.headline3),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      );
    });
  }

  Widget buildListOfTasksTable(context,
      AsyncSnapshot<List<TaskTables>> snapshot, TaskManager taskManager) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        TaskTables tasktable = snapshot.data![index];
        return GestureDetector(
          onTap: () async {
            taskManager.setEachTaskTable(tasktable);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EdittingTasks(taskTable: tasktable),
              ),
            );
          },
          onLongPress: () {
            taskManager.deleteItem(tasktable);
          },
          onDoubleTap: () {
            taskManager.deleteAllTask();
            taskManager.deleteAllTable();
          },
          child: TaskCard(taskTables: tasktable),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(width: 10),
      itemCount: snapshot.data!.length,
    );
  }
}
