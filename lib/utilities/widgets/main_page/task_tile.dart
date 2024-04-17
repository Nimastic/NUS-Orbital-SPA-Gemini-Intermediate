import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colours.dart';
import '../../../constants/theme.dart';
import '../../../services/cloud/tasks/cloud_task.dart';
import '../../../views/features/to-do list/edit_task.dart';

class MainPageTaskTile extends StatelessWidget {
  const MainPageTaskTile({
    super.key,
    required this.task,
  });

  final CloudTask task;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Get.to(() => EditTaskView(task: task));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        height: 120,
        width: 110,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              lightOrange,
              lightPink
            ]
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.title,
                style: tasksTileTitleStyle,
              ),
              Text(
                task.text,
                style: tasksTileTextStyle,
              )
            ],
          ),
        ),
      ),
    );
  }
}