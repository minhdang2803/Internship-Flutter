import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todoist/components/components.dart';
import 'screens.dart';
import '../theme.dart';

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
                  text: "Tasks",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  )),
              TextSpan(
                  text: "Done",
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

  Widget buildTasksList(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => GestureDetector(
          child: const TaskCard(),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EdittingTasks()),
          ),
        ),
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemCount: 10,
      ),
    );
  }
}
