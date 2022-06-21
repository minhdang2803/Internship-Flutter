import 'package:flutter/material.dart';
import 'package:todoist/database_helper.dart';
import 'package:todoist/models/models.dart';
import 'package:todoist/theme.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({Key? key, required this.taskTables}) : super(key: key);
  final TaskTables taskTables;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width * 0.55,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color(int.parse(widget.taskTables.color))),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(widget.taskTables.name,
              style: TaskistTheme.lightTextTheme.headline3!
                  .copyWith(color: Colors.white)),
          const SizedBox(height: 20),
          buildDividerLine(context),
          const SizedBox(height: 20),
          buildListOfTasks(),
        ],
      ),
    );
  }

  Widget buildDividerLine(context) {
    return Row(
      children: [
        SizedBox(width: MediaQuery.of(context).size.width * 0.2),
        const Flexible(child: Divider(color: Colors.white, thickness: 2))
      ],
    );
  }

  Widget buildListOfTasks() {
    return Expanded(
      // height: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: FutureBuilder(
          future: DatabaseHelper.instance.getTasks(widget.taskTables),
          builder: (context, AsyncSnapshot<List<Task>> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                  child: Text('No tasks done',
                      style: TaskistTheme.lightTextTheme.headline2));
            } else if (snapshot.hasError) {
              return Center(
                  child: Text(snapshot.error.toString(),
                      style: TaskistTheme.lightTextTheme.headline2));
            } else if (snapshot.hasData) {
              return ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(height: 5),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Task task = snapshot.data![index];
                  return Row(
                    children: [
                      task.check_val == '0'
                          ? const Icon(Icons.circle_outlined)
                          : const Icon(Icons.check_circle_outline_outlined),
                      const SizedBox(width: 3),
                      Text(
                        task.name,
                        style: TaskistTheme.lightTextTheme.headline3,
                      )
                    ],
                  );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
