import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todoist/components/components.dart';
import 'package:todoist/models/models.dart';
import 'screens.dart';
import '../theme.dart';

class AddedTasks extends StatefulWidget {
  const AddedTasks({Key? key}) : super(key: key);

  @override
  State<AddedTasks> createState() => _AddedTasksState();
}

class _AddedTasksState extends State<AddedTasks> {
  final List<TasksTable> _listOfTaskTables = [];
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
            buildAddTaskButton(),
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
    String dateOfWeek = DateFormat('EEEE').format(time);
    String date = DateFormat('d MMM').format(time);
    return Container(
      padding: const EdgeInsets.only(left: 35, right: 35, top: 20),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(dateOfWeek, style: TaskistTheme.lightTextTheme.headline2),
          Text(date, style: TaskistTheme.lightTextTheme.headline2),
        ],
      ),
    );
  }

  Widget buildVerticalLine() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const Flexible(
          child: Divider(
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 50),
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                  text: "Task",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  )),
              TextSpan(
                  text: "Lists",
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 30,
                    fontWeight: FontWeight.w400,
                  )),
            ],
          ),
        ),
        const SizedBox(width: 50),
        const Flexible(
          child: Divider(
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget buildAddTaskButton() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black45,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddingTasks(),
              ),
            ).then((value) => setState(() {})),
            icon: const Icon(Icons.add, size: 30),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Add List',
          style: TextStyle(color: Colors.black45),
        )
      ],
    );
  }

  // Widget buildTasksList(context) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 35),
  //     child: ListView.separated(
  //       physics: const BouncingScrollPhysics(),
  //       scrollDirection: Axis.horizontal,
  //       itemBuilder: (context, index) => GestureDetector(
  //         onTap: () => Navigator.push(context,
  //             MaterialPageRoute(builder: (context) => const EdittingTasks())),
  //         child: const TaskCard(),
  //       ),
  //       separatorBuilder: (context, index) => const SizedBox(width: 10),
  //       itemCount: 10,
  //     ),
  //   );
  // }

  Widget buildTasksList(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const EdittingTasks())),
          child: const TaskCard(),
        ),
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemCount: 10,
      ),
    );
  }
}
