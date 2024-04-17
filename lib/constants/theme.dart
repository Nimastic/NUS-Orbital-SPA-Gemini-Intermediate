import 'package:flutter/material.dart';

import 'colours.dart';

class Themes {

  static final light = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: darkBlue,
      background: Colors.white
    ),
    useMaterial3: true,
  );

}

TextStyle get pageHeaderStyle {
  return const TextStyle(
    fontFamily: 'GT Walsheim',
    fontSize: 24,
    fontWeight: FontWeight.bold
  );
}

// Main page
TextStyle get navStyle {
  return const TextStyle(
    fontFamily: 'GT Walsheim',
    fontSize: 20,
    overflow: TextOverflow.ellipsis
  );
}

TextStyle get headerNameStyle {
  return const TextStyle(
    fontFamily: 'GT Walsheim',
    fontWeight: FontWeight.w400,
    fontSize: 20,
    overflow: TextOverflow.ellipsis
  );
}
TextStyle get headerTaskStyle {
  return const TextStyle(
    fontFamily: 'GT Walsheim',
    fontWeight: FontWeight.w800,
    fontSize: 24,
    overflow: TextOverflow.ellipsis
  );
}

TextStyle get barTitleStyle {
  return const TextStyle(
    fontFamily: 'GT Walsheim',
    fontWeight: FontWeight.w800,
    fontSize: 24,
    overflow: TextOverflow.ellipsis
  );
}

TextStyle get tasksTileTitleStyle {
  return const TextStyle(
    fontFamily: 'GT Walsheim',
    fontWeight: FontWeight.w800,
    fontSize: 22,
    overflow: TextOverflow.ellipsis
  );
}

TextStyle get tasksTileTextStyle {
  return TextStyle(
    fontFamily: 'GT Walsheim',
    color: Colors.grey[600],
    fontSize: 18,
    overflow: TextOverflow.ellipsis
  );
}

// Create events/reminders/tasks
TextStyle get titleStyle {
  return const TextStyle(
    fontFamily: 'GT Walsheim',
    fontWeight: FontWeight.w800,
    fontSize: 20
  );
}

TextStyle get hintStyle {
  return const TextStyle(
    fontFamily: 'GT Walsheim',
    fontSize: 16,
    overflow: TextOverflow.ellipsis
  );
}

TextStyle get buttonStyle {
  return const TextStyle(
    fontFamily: 'GT Walsheim',
    fontSize: 18
  );
}

// to do list view
TextStyle get taskTitleStyle {
  return const TextStyle(
    fontFamily: 'GT Walsheim',
    fontWeight: FontWeight.bold,
    fontSize: 22,
    overflow: TextOverflow.ellipsis
  );
}

TextStyle get taskTextStyle {
  return const TextStyle(
    fontFamily: 'GT Walsheim',
    fontWeight: FontWeight.w400,
    fontSize: 18,
    overflow: TextOverflow.ellipsis
  );
}

//calendar view
TextStyle get headerTimelineDayTextStyle {
  return const TextStyle(
    fontFamily: 'GT Walsheim',
    fontWeight: FontWeight.bold,
    fontSize: 24,
    overflow: TextOverflow.ellipsis
  );
}

TextStyle get headerTextStyle {
  return const TextStyle(
    fontFamily: 'GT Walsheim',
    fontWeight: FontWeight.w400,
    fontSize: 18,
    overflow: TextOverflow.ellipsis
  );
}

TextStyle get dayTitleTextStyle {
  return const TextStyle(
    fontFamily: 'GT Walsheim',
    fontWeight: FontWeight.w500,
    fontSize: 18,
    overflow: TextOverflow.ellipsis
  );
}

TextStyle get dayAllDayTitleTextStyle {
  return const TextStyle(
    fontFamily: 'GT Walsheim',
    fontWeight: FontWeight.w500,
    fontSize: 13,
    overflow: TextOverflow.ellipsis
  );
}

TextStyle get weekTitleTextStyle {
  return const TextStyle(
    fontFamily: 'GT Walsheim',
    fontWeight: FontWeight.w500,
    fontSize: 14,
    overflow: TextOverflow.ellipsis
  );
}

TextStyle get weekAllDayTitleTextStyle {
  return const TextStyle(
    fontFamily: 'GT Walsheim',
    fontWeight: FontWeight.w500,
    fontSize: 12,
    overflow: TextOverflow.ellipsis
  );
}

TextStyle get scheduleTitleTextStyle {
  return const TextStyle(
    fontFamily: 'GT Walsheim',
    fontWeight: FontWeight.w500,
    fontSize: 16,
    overflow: TextOverflow.ellipsis
  );
}

TextStyle get scheduleAllDayTitleTextStyle {
  return const TextStyle(
    fontFamily: 'GT Walsheim',
    fontWeight: FontWeight.w500,
    fontSize: 13,
    overflow: TextOverflow.ellipsis
  );
}

TextStyle get scheduleFromDateTextStyle {
  return const TextStyle(
    fontFamily: 'GT Walsheim',
    fontSize: 14,
    overflow: TextOverflow.ellipsis
  );
}

TextStyle get scheduleToDateTextStyle {
  return TextStyle(
    fontFamily: 'GT Walsheim',
    fontSize: 12,
    color: Colors.grey[600],
    overflow: TextOverflow.ellipsis
  );
}