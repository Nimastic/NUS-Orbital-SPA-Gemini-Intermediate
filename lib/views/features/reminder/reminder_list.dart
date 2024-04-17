import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orbital_spa/constants/colours.dart';
import 'package:orbital_spa/constants/theme.dart';
import 'package:orbital_spa/utilities/widgets/features/reminder_tile.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../services/auth/data/repositories/auth_repository.dart';
import '../../../services/cloud/reminders/firebase_cloud_reminders_storage.dart';
import '../../../utilities/widgets/features/button.dart';
import 'add_reminder.dart';

class ReminderListView extends StatefulWidget {
  const ReminderListView({super.key});

  @override
  State<ReminderListView> createState() => _ReminderListViewState();
}

class _ReminderListViewState extends State<ReminderListView> {
  late final FirebaseCloudReminderStorage _reminderService;
  String get userId => AuthRepository.firebase().currentUser!.id;

  @override
  void initState() {
    super.initState();
    _reminderService = FirebaseCloudReminderStorage();
  }
 
  _appBar() {
    return AppBar(
      backgroundColor: background,
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: const Icon(Icons.arrow_back_ios)
      ),

      title: Text(
        'My Reminders',
        style: pageHeaderStyle,
      ),
      centerTitle: true,

    );
  }

  Widget _calendar() {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      height: 150,
      width: 350,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: white
      ),

      child: SfCalendar(
        view: CalendarView.month,
        monthViewSettings: const MonthViewSettings(
          numberOfWeeksInView: 1,
          dayFormat: 'EEE',
          monthCellStyle: MonthCellStyle(
            // todayBackgroundColor: lightGreen,
            textStyle: TextStyle(
              fontFamily: 'GT Walsheim',
              fontSize: 20
            ),
          ),
        ),
        todayTextStyle: const TextStyle(
          fontFamily: 'GT Walsheim',
          fontSize: 20
        ),
        headerStyle: const CalendarHeaderStyle(
          textAlign: TextAlign.center,
          //backgroundColor: 
          textStyle: TextStyle(
            fontFamily: 'GT Walsheim',
            fontWeight: FontWeight.bold,
            fontSize: 22
          )
        ),
        cellBorderColor: Colors.transparent,
      ),
    );
  }

  _showReminders() {
    return Expanded(
      child:
        StreamBuilder(
          stream: _reminderService.allDates(ownerUserId: userId),
          builder: (context, snapshot) {

            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final allDates = snapshot.data!.toList();
                  allDates.sort((a, b) {
                    if (a.isBefore(b)) {
                      return -1;
                    } else if (b.isBefore(a)) {
                      return 1;
                    } else {
                      return 0;
                    }
                  });
                  Set dates = Set.from(allDates.map((e) => DateTime(e.year, e.month, e.day)));
                  return ListView.builder(
                    itemCount: dates.length,
                    itemBuilder: (context, index) {
                      DateTime date = dates.elementAt(index);
                      DateTime day = DateTime(date.year, date.month, date.day);
                      int count = allDates
                          .map((e) {
                            DateTime currDay = DateTime(e.year, e.month, e.day);
                            return currDay.isAtSameMomentAs(day) ? 1 : 0;
                          })
                          .reduce((value, element) => value + element);
                      return ReminderTile(
                        date: day, 
                        numReminders: count,
                      );
                    },
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
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
      body: Stack(
        children: [
          Container(
            color: background,
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15,
            ),
            child: Column(
              children: [
                _calendar(),
                _showReminders(),
              
              ],
            ),
          ),
        ],
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.calendar_month_outlined),
      //       label: "Calendar"
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.assessment_outlined),
      //       label: "To Do"
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.alarm_outlined),
      //       label: "Reminders"
      //     ),
      //   ],
      //   currentIndex: _selectedIndex,
      //   onTap: _onItemTapped, 
      // ),
      floatingActionButton: Container(
        padding: const EdgeInsets.only(top: 10, bottom: 10, right: 15),
        width: 175,
        child: MyButton(
          label: " + Add Reminder", 
          onTap: () async {
            await Get.to(() => (const AddReminderView()));
          },
          innerColour: lightPurple,
          borderColor: lightPurple,
          fontColor: black,
        ),
      ),
    );
  }
}