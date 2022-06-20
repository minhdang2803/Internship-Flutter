import 'package:flutter/material.dart';
import 'package:todoist/theme.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width * 0.55,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.blue),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text('Hello world ads',
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
        child: ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(height: 5),
          itemCount: 15,
          itemBuilder: (context, index) => Row(
            children: [
              const Icon(Icons.circle_outlined),
              const SizedBox(width: 3),
              const Text('Hello World')
            ],
          ),
        ),
      ),
    );
  }
}
