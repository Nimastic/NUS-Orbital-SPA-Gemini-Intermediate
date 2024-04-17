import 'package:flutter/material.dart';

import '../../../constants/theme.dart';
import '../../../services/cloud/events/cloud_event.dart';
import 'event_tile.dart';

class MainPageUpcomingEvents extends StatelessWidget {
  const MainPageUpcomingEvents({
    super.key,
    required this.context,
    required this.upcomingEvents,
  });

  final BuildContext context;
  final Iterable<CloudEvent> upcomingEvents;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upcoming Events',
          style: barTitleStyle,
        ),
        const SizedBox(height: 10,),
        SizedBox(
          height: 300,
          width: MediaQuery.of(context).size.width * 0.9,
          child: ListView.builder(
            itemCount: upcomingEvents.length,
            itemBuilder: (context, index) {
              final event = upcomingEvents.elementAt(index);
              return MainPageEventTile(event: event);
            }
          ),
        )
      ],
    );
  }
}