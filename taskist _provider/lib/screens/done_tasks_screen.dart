import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todoist/components/components.dart';
import 'package:todoist/providers/providers.dart';
import '../models/tasks.dart';
import 'screens.dart';

class DoneTasks extends StatelessWidget {
  const DoneTasks({Key? key}) : super(key: key);

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
            Expanded(child: buildTasksList(context)),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.33,
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
                  text: "Tasks",
                  style: Theme.of(context).textTheme.headline2!.copyWith(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      )),
              TextSpan(
                  text: "Done",
                  style: Theme.of(context).textTheme.headline3!.copyWith(
                      fontSize: 30,
                      color: Colors.grey,
                      fontWeight: FontWeight.w300)),
            ],
          ),
        ),
        const SizedBox(width: 50),
        Flexible(
          child: Divider(
            color: Theme.of(context).colorScheme.primary,
            thickness: 2,
          ),
        ),
      ],
    );
  }

  Widget buildTasksList(context) {
    return Consumer<TaskManager>(builder: (context, taskManager, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: FutureBuilder(
          future: taskManager.getAllDone(),
          builder: (context, AsyncSnapshot<List<TaskTables>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return Center(
                  child: Text('No tasks remain!',
                      style: Theme.of(context).textTheme.headline3),
                );
              } else {
                return buildSmallTasks(context, snapshot, taskManager);
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

  Widget buildSmallTasks(BuildContext context,
      AsyncSnapshot<List<TaskTables>> snapshot, TaskManager taskManager) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) => GestureDetector(
        child: TaskCard(taskTables: snapshot.data![index]),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider.value(
              value: Provider.of<TaskManager>(context, listen: false),
              child: EdittingTasks(taskTable: snapshot.data![index]),
            ),
          ),
        ),
      ),
      separatorBuilder: (context, index) => const SizedBox(width: 10),
      itemCount: snapshot.data!.length,
    );
  }
}
