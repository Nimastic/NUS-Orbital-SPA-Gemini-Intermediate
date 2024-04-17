import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:orbital_spa/constants/colours.dart';
import 'package:orbital_spa/services/auth/data/repositories/auth_repository.dart';
import 'package:orbital_spa/services/cloud/events/cloud_event.dart';
import 'package:orbital_spa/services/cloud/events/firebase_cloud_event_storage.dart';
import 'package:orbital_spa/services/notifications/notifications_service.dart';
import 'package:orbital_spa/views/features/to-do%20list/add_task_view.dart';
import '../../services/cloud/tasks/cloud_task.dart';
import '../../services/cloud/tasks/firebase_cloud_task_storage.dart';
import '../../utilities/widgets/features/button.dart';
import '../../utilities/widgets/features/event_tile.dart';
import '../../utilities/widgets/features/task_tile.dart';
import 'calendar/add_event_view.dart';

class CalendarListView extends StatefulWidget {
  const CalendarListView({super.key});

  @override
  State<CalendarListView> createState() => _CalendarListViewState();
}

class _CalendarListViewState extends State<CalendarListView> {

  late NotifyHelper notifyHelper;
  late final FirebaseCloudTaskStorage _taskService;
  late final FirebaseCloudEventStorage _eventService;
  String get userId => AuthRepository.firebase().currentUser!.id;

  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _taskService = FirebaseCloudTaskStorage();
    _eventService = FirebaseCloudEventStorage();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
  }


  _appBar() {
    return AppBar(
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: const Icon(Icons.arrow_back_ios)
      ),
    );
  }

  _taskBar() {
    return Container(
      margin: const EdgeInsets.only(left:20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(DateFormat.yMMMd().format(DateTime.now()),
                // style: subHeadingStyle                  
              ),
              const Text('Today',
                // style: headingStyle
              )
            ],
          ),
          Row(
            children: [
              MyButton(
                label: "+ Add Task", 
                onTap: () async {
                  await Get.to(() => (const AddTaskView()));
                },
                innerColour: blue,
                borderColor: blue,
                fontColor: white,
              ),
              const SizedBox(width: 10,),
              MyButton(
                label: "+ Add Event", 
                onTap: () async {
                  await Get.to(() => (const AddEventView()));
                },
                innerColour: blue,
                borderColor: blue,
                fontColor: white,
              ),
            ],
          )
        ],
        ),
    );
  }

  _dateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        // selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        // dateTextStyle: GoogleFonts.lato(
        //   textStyle: const TextStyle(
        dateTextStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey
          ),
        // ),
        // dayTextStyle: GoogleFonts.lato(
        //   textStyle: const TextStyle(
        dayTextStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey
          ),
        // ),
        // monthTextStyle: GoogleFonts.lato(
        //   textStyle: const TextStyle(
          monthTextStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey
          ),
        // ),
        onDateChange: (selectedDate) {
          setState(() {
            _selectedDate = selectedDate;
          });
        },
      )
    );
  }

  _showTasks() {
    return 
    Expanded(
      child:
        StreamBuilder(
          stream: _taskService.allDocs(ownerUserId: userId),
          builder: (context, snapshot) {

            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final allTasks = snapshot.data as Iterable<CloudTask>;
                  return ListView.builder(
                    itemCount: allTasks.length,
                    itemBuilder: (context, index) {
                      final task = allTasks.elementAt(index);
                      final deadline = DateTime.parse(task.deadline);

                      // Tasks repeated daily are shown everyday
                      // if (task.repeat == 1) {

                        // var myTime = DateFormat.jm().parse(task.startTime);
                        // DateTime date = DateFormat.jm().parse(task.startTime.toString());
                        // DateTime date = DateFormat("h :mm a").format(parse(task.startTime));
                        // print(date);
                        // // print(task.startTime);
                        // var myTime = DateFormat("HH:mm").format(date);
                        // print(myTime);
                        // var myTime = task.startTime.toString();
                        // int hour = int.parse(myTime.split(":")[0]);
                        // int minutes = int.parse(myTime.split(":")[1].split(" ")[0]);
                        // bool isMorning = myTime.split(":")[1].split(" ")[1] == "AM";
                        // notifyHelper.scheduledNotification(
                        //   // int.parse(myTime.toString().split(":")[0]),
                        //   // int.parse(myTime.toString().split(":")[1]),
                        //   // 12,
                        //   // 16,
                        //   hour,
                        //   minutes,
                        //   task,
                        //   isMorning
                        // );

                        // return AnimationConfiguration.staggeredList(
                        //   position: index, 
                        //   child: SlideAnimation(
                        //     child: FadeInAnimation(
                        //       child: Row(
                        //         children: [

                        //           GestureDetector(
                        //             onTap: () {
                        //               _showBottomSheet(context, task);
                        //             },
                        //             child: TaskTile(task: task),
                        //           )
                        //         ],
                        //       )
                        //     )
                        //   )
                        // );
                      
                      // Tasks repeated weekly are shown every week
                      // } else if (task.repeat == 2) {
                      // }

                      if (DateFormat.yMd().format(deadline) == DateFormat.yMd().format(_selectedDate)) {
                        return AnimationConfiguration.staggeredList(
                          position: index, 
                          child: SlideAnimation(
                            child: FadeInAnimation(
                              child: Row(
                                children: [

                                  GestureDetector(
                                    onTap: () {
                                      _showBottomSheet(context, task);
                                    },
                                    child: TaskTile(task: task),
                                  )
                                ],
                              )
                            )
                          )
                        );
                      } else {
                        return Container();
                      }
                    }
                  );
              
                } else {
                  return const CircularProgressIndicator();
                }
              default: return const CircularProgressIndicator();
            }
          },
        )
    );
  }

  _showBottomSheet(BuildContext context, CloudTask task) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        height: task.isCompleted == 1  
                ? MediaQuery.of(context).size.height * 0.24 
                : MediaQuery.of(context).size.height * 0.32,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[300]
              ),
            ),
            const Spacer(),
            task.isCompleted == 1
            ? Container()
            : _bottomSheetButton(
              label: "Complete Task", 
              onTap: () {
                _taskService.completeTask(documentId: task.documentId, isCompleted: 1);
                Get.back();
              }, 
              clr: Colors.blue,
              context: context
            ),
            // const SizedBox(height: 20),
            _bottomSheetButton(
              label: "Delete Task", 
              onTap: () {
                _taskService.deleteTask(documentId: task.documentId);
                Get.back();
              }, 
              clr: Colors.red,
              context: context
            ),
            const SizedBox(height: 20),
            _bottomSheetButton(
              label: "Close", 
              onTap: () {
                Get.back();
              }, 
              clr: Colors.red,
              context: context,
              isClose: true
            ),
            const SizedBox(height: 10),
          ],
        ),
      )
    );
  }

  _bottomSheetButton({
    required String label,
    required Function()? onTap,
    required Color clr,
    required BuildContext context,
    bool isClose = false
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose ? Colors.grey[300]! : clr
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose ? Colors.transparent : clr
        ),
        child: Center(
          child: Text(
            label,
            style: isClose 
                   ? const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black
                   )
                   : const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white
                   ) ,
          )
        ),
      )
    );
  }

  _showEvents() {
    return 
    Expanded(
      child: 
      StreamBuilder(
        stream: _eventService.allEvents(ownerUserId: userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final allEvents = snapshot.data as Iterable<CloudEvent>;
                  return ListView.builder(
                    itemCount: allEvents.length,
                    itemBuilder: (context, index) {
                      final event = allEvents.elementAt(index);
                      DateTime from = DateTime.parse(event.from.split(' ')[0]);
                      DateTime to = DateTime.parse(event.to.split(' ')[0]);

                      if (from.isAtSameMomentAs(_selectedDate) || from.isBefore(_selectedDate)) {
                        if (to.isAtSameMomentAs(_selectedDate) || to.isAfter(_selectedDate)) {
                          return AnimationConfiguration.staggeredList(
                            position: index, 
                            child: SlideAnimation(
                              child: FadeInAnimation(
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        
                                      },
                                      child: EventTile(event: event),
                                    )
                                  ],
                                )
                              )
                            )
                          );
                        } 
                      }
                      return Container();
                    }
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              default: return const CircularProgressIndicator();
          }
        },
      )
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          _taskBar(),
          _dateBar(),
          const SizedBox(height: 10),

          const Text(
            "Tasks",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),
          ),
          const SizedBox(height: 10),
          _showTasks(),
          const SizedBox(height: 10),

          const Text(
            "Events",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),
          ),
          const SizedBox(height: 10),
          _showEvents()
        ],
      )
    );
  }
}