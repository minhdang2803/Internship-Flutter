import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todoist/components/components.dart';
import 'package:todoist/database_helper.dart';
import '../models/tasks.dart';
import 'screens.dart';

class DoneTasks extends StatefulWidget {
  const DoneTasks({Key? key}) : super(key: key);

  @override
  State<DoneTasks> createState() => _DoneTasksState();
}

class _DoneTasksState extends State<DoneTasks> {
  late DateTime time;
  @override
  void initState() {
    time = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            buildDateTime(),
            const SizedBox(height: 20),
            buildVerticalLine(),
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
    String dateOfWeek = DateFormat('EEEE').format(time);
    String date = DateFormat('d MMM').format(time);
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
  }

  Widget buildVerticalLine() {
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
                    fontWeight: FontWeight.w300),
              ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: FutureBuilder(
        future: DatabaseHelper.instance.getAllDone(),
        builder: (context, AsyncSnapshot<List<TaskTables>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return ListView.separated(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => GestureDetector(
                  child: TaskCard(taskTables: snapshot.data![index]),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            EdittingTasks(task: snapshot.data![index])),
                  ).then((value) => setState(() {})),
                ),
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemCount: snapshot.data!.length,
              );
            } else if (snapshot.data!.isEmpty) {
              return Center(
                  child: Text('No tasks done!',
                      style: Theme.of(context).textTheme.headline3));
            } else {
              return Center(
                  child: Text(snapshot.error.toString(),
                      style: Theme.of(context).textTheme.headline2));
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
