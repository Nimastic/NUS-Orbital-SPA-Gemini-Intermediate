import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colours.dart';
import '../../../constants/theme.dart';
import '../../../views/features/assistant/assistant_chat_view.dart';
import '../../../views/features/calendar/calendar_view.dart';
import '../../../views/features/reminder/reminder_list.dart';
import '../../../views/features/to-do list/to_do_list_view.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({
    required this.context,
    super.key,
  });

  final BuildContext context;


  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: background,
      child: ListView(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          // DrawerHeader(
          //   child: 'Nav menu'
          // )
          ListTile(
            leading: const Icon(Icons.home),
            title: Text(
              'Home Page',
              style: navStyle,
            ),
            onTap: () {
              Navigator.of(context).pop();
            }
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month_outlined),
            title: Text(
              'Calendar',
              style: navStyle,
            ),
            onTap: () async {
              Navigator.of(context).pop();
              await Get.to(() => const CalendarMonthView());
            }
          ),
          ListTile(
            leading: const Icon(Icons.assessment_outlined),
            title: Text(
              'To Do List',
              style: navStyle,
            ),
            onTap: () async {
              Navigator.of(context).pop();
              await Get.to(() => const ToDoListView());
            }
          ),
          ListTile(
            leading: const Icon(Icons.alarm_outlined),
            title: Text(
              'Reminder',
              style: navStyle,
            ),
            onTap: () async {
              Navigator.of(context).pop();
              await Get.to(() => const ReminderListView());
            }
          ),
          ListTile(
            leading: const Icon(Icons.android_outlined),
            title: Text(
              'Voice Assistant',
              style: navStyle,
            ),
            onTap: () {
              Navigator.of(context).pop();
              Get.to(() => const AssistantChatView());
            }
          )
        ],
      ),
    );
  }
}