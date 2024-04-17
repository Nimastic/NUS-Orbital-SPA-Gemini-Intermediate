import 'package:flutter/material.dart';

import '../../../constants/colours.dart';

class MainPageEventTag extends StatelessWidget {
  const MainPageEventTag({
    super.key,
    required this.progress,
  });

  final int progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: progress == 0 
               ? const Color(0xFFb9ec86)
               : progress == 1
               ? const Color(0xFFe0f7ca)
               : white
      ),
      child: Text(
        progress == 0
        ? 'Upcoming'
        : progress == 1
        ? 'In Progress'
        : 'Ended',
        style: const TextStyle(
          fontFamily: 'GT Walsheim'
        )
      )

    );
  }
}