import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../services/cloud/events/cloud_event.dart';

class MainPageEventFrom extends StatelessWidget {
  const MainPageEventFrom({
    super.key,
    required this.event,
  });

  final CloudEvent event;

  @override
  Widget build(BuildContext context) {
    String time = '';
    if (event.isAllDay == 0) {
      time = "${DateFormat.MMMd().format(DateTime.parse(event.from))} ${DateFormat.jm().format(DateTime.parse(event.from))}";
    }
    return Text(
      'Starts: $time',
      style: const TextStyle(
        fontFamily: 'GT Walsheim'
      ),
    );
  }
}