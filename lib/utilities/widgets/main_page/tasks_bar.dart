import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orbital_spa/utilities/widgets/main_page/task_tile.dart';

import '../../../constants/theme.dart';
import '../../../services/cloud/tasks/cloud_task.dart';
import '../../../views/features/to-do list/to_do_list_view.dart';

class MainPageTasksBar extends StatelessWidget {
  const MainPageTasksBar({
    super.key,
    required this.context,
    required this.todoTasks,
  });

  final BuildContext context;
  final Iterable<CloudTask> todoTasks;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 188,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20)
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Ongoing Tasks',
                style: barTitleStyle,
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Get.to(() => const ToDoListView());
                }, 
                child: const Text('View All', style: TextStyle(fontFamily: 'GT Walsheim'))
              )
            ],
          ),
          const SizedBox(height: 10,),
          SizedBox(
            height: 120,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: todoTasks.length,
              itemBuilder: (context, index) {
                final task = todoTasks.elementAt(index);
                return MainPageTaskTile(task: task);
              }
            ),
          )
        ],
      ),
    );
  }
}