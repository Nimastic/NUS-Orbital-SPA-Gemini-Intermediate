import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:orbital_spa/constants/colours.dart';
import 'package:orbital_spa/constants/images_strings.dart';
import 'package:orbital_spa/constants/theme.dart';
import 'package:orbital_spa/menu_items/menu_actions.dart';
import 'package:orbital_spa/services/auth/bloc/auth_bloc.dart';
import 'package:orbital_spa/services/auth/bloc/auth_events.dart';
import 'package:orbital_spa/services/cloud/events/cloud_event.dart';
import 'package:orbital_spa/services/cloud/events/firebase_cloud_event_storage.dart';
import 'package:orbital_spa/services/cloud/reminders/firebase_cloud_reminders_storage.dart';
import 'package:orbital_spa/services/cloud/tasks/cloud_task.dart';
import 'package:orbital_spa/utilities/widgets/main_page/upcoming_events.dart';
import 'package:orbital_spa/views/features/calendar/edit_event.dart';
import 'package:orbital_spa/views/features/to-do%20list/edit_task.dart';
import 'package:orbital_spa/views/features/to-do%20list/to_do_list_view.dart';
import '../services/auth/data/repositories/auth_repository.dart';
import '../services/cloud/tasks/firebase_cloud_task_storage.dart';
import '../services/notifications/notifications_service.dart';
import '../utilities/dialogs/logout_dialog.dart';
import '../utilities/widgets/main_page/header.dart';
import '../utilities/widgets/main_page/nav_drawer.dart';
import '../utilities/widgets/main_page/tasks_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  late NotifyHelper notifyHelper;

  late final FirebaseCloudTaskStorage taskService;
  late final FirebaseCloudEventStorage eventService;
  late final FirebaseCloudReminderStorage reminderStorage;
  String get userId => AuthRepository.firebase().currentUser!.id;
  String get name => AuthRepository.firebase().currentUser!.userName;

  // int _selectedIndex = 0;
  int todoNum = 0;
  int allNum = 0;


  @override
  void initState() {
    super.initState();
    taskService = FirebaseCloudTaskStorage();
    eventService = FirebaseCloudEventStorage();
    reminderStorage = FirebaseCloudReminderStorage();
  }

  PreferredSizeWidget? appBar() {
    return AppBar(
      backgroundColor: background,
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                final shouldLogout = await showLogOutDialog(context);

                // Back to login page after successful logout
                if (shouldLogout) {
                  if (context.mounted) {
                  context.read<AuthBloc>().add(const AuthEventLogOut());
                  }
                }
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text(
                    'Log out',
                    style: TextStyle(
                      fontFamily: 'GT Walsheim'
                    ),
                  ),
                )
              ];
            },
          )
        ]
      );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(mainPageBackground),
          fit: BoxFit.cover
        ),
      ),
      child: Scaffold(    
        backgroundColor: transparent,
        appBar: appBar(),
    
        drawer: NavDrawer(context: context,),
    
        body: StreamBuilder(
          stream: taskService.allDocs(ownerUserId: userId),
          builder: (context1, snapshot1) {
            return StreamBuilder(
              stream: eventService.allEvents(ownerUserId: userId),
              builder: (context2, snapshot2) {
                return StreamBuilder(
                  stream: reminderStorage.allReminders(ownerUserId: userId),
                  builder: (context3, snapshot3) {
                    switch (snapshot3.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                      if (snapshot1.hasData && snapshot2.hasData && snapshot3.hasData) {
                        final allTasks = snapshot1.data as Iterable<CloudTask>;
                        final allEvents = snapshot2.data as Iterable<CloudEvent>;
                        // final allReminders = snapshot3.data as Iterable<CloudReminder>;
    
                        final todoTasks = allTasks.where((task) => task.isCompleted == 0);
                        todoNum = todoTasks.length;
                        allNum = allTasks.length;
                        final upcomingEvents = allEvents
                            .where((event) => DateTime.parse(event.from).isAfter(DateTime.now().subtract(const Duration(days: 1))));
                        // day's events
                        // upcoming reminders
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              MainPageHeader(context: context, name: name, todo: todoNum),
                              const SizedBox(height: 40,),
                              MainPageTasksBar(context: context, todoTasks: todoTasks),
                              const SizedBox(height: 20,),
                              // _remindersBar(allReminders),
                              MainPageUpcomingEvents(context: context, upcomingEvents: upcomingEvents)
                            ],
                          ),
                        );
                        
                      } else {
                        return const CircularProgressIndicator();
                      }
    
                      default: return const CircularProgressIndicator();
                    }
                  }
                );
              }
            );
          }
        ),
    
      ),
    );
  }
}













