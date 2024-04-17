import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:orbital_spa/constants/colours.dart';

import '../../../services/cloud/tasks/cloud_task.dart';

class TaskTile extends StatelessWidget {
  final CloudTask? task;
  const TaskTile({super.key, this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: lightBlue
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task?.title ?? "",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      color: Colors.grey[200],
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      // task!.deadline,
                      DateFormat.yMMMMd().format(DateTime.parse(task!.deadline)),
                      style: TextStyle(fontSize: 13, color: Colors.grey[100]),
                    ),
                  ],
                ),
                  Text(
                    task?.text ?? "",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[100]
                    ),
                  )
                ],
              )
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: 60,
              width: 0.5,
              color: Colors.grey[200]!.withOpacity(0.7),
            ),
            RotatedBox(
              quarterTurns: 3,
              child: Text(
                task!.isCompleted == 1 ? "COMPLETED" : "TO DO",
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}