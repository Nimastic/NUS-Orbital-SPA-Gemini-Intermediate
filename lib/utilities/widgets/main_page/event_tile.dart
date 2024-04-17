import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colours.dart';
import '../../../services/cloud/events/cloud_event.dart';
import '../../../views/features/calendar/edit_event.dart';
import 'event_from.dart';
import 'event_tag.dart';

class MainPageEventTile extends StatelessWidget {
  const MainPageEventTile({
    super.key,
    required this.event,
  });

  final CloudEvent event;

  @override
  Widget build(BuildContext context) {

    DateTime from = DateTime.parse(event.from);
    DateTime to = DateTime.parse(event.to);

    int progress = from.isAfter(DateTime.now())
                   ? 0 // Upcoming event
                   : to.isAfter(DateTime.now()) || event.isAllDay == 1
                   ? 1 // In progress
                   : 2; //Event has ended
    return GestureDetector(
      onTap: () async {
        await Get.to(() => EditEventView(event: event));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [
              lightPurple,
              lightBlue
            ]
          )
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                    fontFamily: 'GT Walsheim',
                    fontSize: 22
                  )
                ),
                Text(
                  event.description,
                  style: const TextStyle(
                    fontFamily: 'GT Walsheim'
                  ),
                ),
                MainPageEventFrom(event: event)
              ],
            ),
            const Spacer(),
            MainPageEventTag(progress: progress)
          ],
        ),
      ),
    );
  }
}