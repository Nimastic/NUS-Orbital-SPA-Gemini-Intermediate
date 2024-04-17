import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:orbital_spa/constants/colours.dart';
import 'package:orbital_spa/services/cloud/reminders/cloud_reminder.dart';
import 'package:orbital_spa/views/features/reminder/edit_reminder.dart';

import '../../../services/auth/data/repositories/auth_repository.dart';
import '../../../services/cloud/reminders/firebase_cloud_reminders_storage.dart';

class ReminderTile extends StatefulWidget {

  final DateTime date;
  final int numReminders;

  const ReminderTile({
    super.key, 
    required this.date, 
    required this.numReminders,
  });

  @override
  State<ReminderTile> createState() => _ReminderTileState();
}

class _ReminderTileState extends State<ReminderTile> {

  late final FirebaseCloudReminderStorage _reminderService;
  String get userId => AuthRepository.firebase().currentUser!.id;

  late double height;

  @override
  void initState() {
    super.initState();
    _reminderService = FirebaseCloudReminderStorage();
    height = widget.numReminders * 65 + 44;
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        // border: Border.all(
        //   color: Colors.grey[300]!
        // ),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [ lightBlue,background ]
        )
      ),
      height: widget.numReminders * 70 + 55,
      margin: const EdgeInsets.only(bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            // color: Colors.purple,
            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            height: 30,
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_month_outlined,
                  color: dayDate,
                ),
                const SizedBox(width: 10,),
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  child: Text(
                    DateFormat('MMMMd').format(widget.date),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'GT Walsheim',
                      color: dayDate
                    ),
                  ),
                ),
              ],
            )
          ),
          Expanded(
            child: StreamBuilder(
              stream: _reminderService.dayReminder(ownerUserId: userId, date: widget.date),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    if (snapshot.hasData) {
                      final allDayReminders = snapshot.data as Iterable<CloudReminder>;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: allDayReminders.length,
                        itemBuilder: (context, index) {
                          final reminder = allDayReminders.elementAt(index);
                          DateTime byDate = DateTime.parse(reminder.by);
          
                          String hour = DateFormat('h').format(byDate).toString();
                          String amPm = DateFormat('a').format(byDate).toString();

          

                          return SizedBox(
                            height: 70,
                            child: ListTile(
                              leading: Container(
                                padding: const EdgeInsets.only(top: 10),
                                width: 75,
                                child: Row(
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          hour,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'GT Walsheim',
                                            color: Color(0xFF961857),
                                            fontWeight: FontWeight.w500
                                          ),
                                        ),
                                        Text(
                                          amPm,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'GT Walsheim',
                                            color: Color(0xFF961857)
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(width: 5,),
                                    Transform.scale(
                                      scale: 1.5,
                                      child: Checkbox(
                                        activeColor: Color(0xFF961857),
                                        value: reminder.isCompleted == 1,
                                        onChanged: (value) {
                                          _reminderService.completeReminder(
                                              documentId: reminder.documentId, 
                                              isCompleted: reminder.isCompleted == 1 ? 0 : 1
                                          );
                                        },
                                        shape: const CircleBorder(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                                    
                              onTap: () {
                                Get.to(() => EditReminderView(reminder: reminder,));
                              },
                                    
                              title: Container(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  reminder.title,
                                  style: TextStyle(
                                    decoration: reminder.isCompleted == 1 ? TextDecoration.lineThrough : null,
                                    fontFamily: 'GT Walsheim',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    overflow: TextOverflow.ellipsis
                                  ),
                                ),
                              ),
                                    
                              trailing: Container(
                                margin: const EdgeInsets.symmetric(vertical: 12),
                                child: IconButton(
                                  onPressed: () {
                                    _reminderService.deleteReminder(documentId: reminder.documentId);
                                  },
                                  icon: const Icon(Icons.delete_outline_rounded),
                                  iconSize: 26,
                                ),
                              )
                                    
                            ),
                          );
                        }
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  default: return const CircularProgressIndicator();
                }
              }
            ),
          ),
        ],
      ),
    );
  }
}