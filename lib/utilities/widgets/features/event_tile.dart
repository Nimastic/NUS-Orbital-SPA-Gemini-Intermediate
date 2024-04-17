import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:orbital_spa/services/cloud/events/cloud_event.dart';


class EventTile extends StatelessWidget {
  final CloudEvent? event;
  const EventTile({super.key, this.event});

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
          color: Colors.pink[200]
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event?.title ?? "",
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
                      "${DateFormat.yMMMMd().add_jm().format(DateTime.parse(event!.from))} - ${DateFormat.yMMMMd().add_jm().format(DateTime.parse(event!.to))}" ,
                      style: TextStyle(fontSize: 13, color: Colors.grey[100]),
                    ),
                  ],
                ),
                  Text(
                    event?.description ?? "",
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
            const RotatedBox(
              quarterTurns: 3,
              child: Text(
                "EVENT",
                style: TextStyle(
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