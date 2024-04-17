import 'package:flutter/material.dart';
import 'package:orbital_spa/services/cloud/events/cloud_event.dart';
import 'package:orbital_spa/services/cloud/events/firebase_cloud_event_storage.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../../services/auth/data/repositories/auth_repository.dart';
import '../../../services/calendar/event_data_source.dart';

class TaskWidget extends StatefulWidget {

  final DateTime currDate;

  const TaskWidget({super.key, required this.currDate});

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {

  late final FirebaseCloudEventStorage _eventStorage;
  String get userId => AuthRepository.firebase().currentUser!.id;

  @override
  void initState() {
    super.initState();
    _eventStorage = FirebaseCloudEventStorage();
  }


  Widget appointmentBuilder(
    BuildContext context,
    CalendarAppointmentDetails details
  ) {
    final event = details.appointments.first;
    return Container(
      width: details.bounds.width,
      height: details.bounds.height,
      decoration: BoxDecoration(
        color: Colors.pink[100],
        borderRadius: BorderRadius.circular(12)
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: Column(
            children: [
              Text(
                event.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              ),
              Text(
                event.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              )
            ],
          ),
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    
    List<CloudEvent> dayEvents = [];
    return StreamBuilder(
      stream: _eventStorage.allEvents(
        ownerUserId: userId, 
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.active:
            if (snapshot.hasData) {
              dayEvents = snapshot.data!.toList();
              // dayEvents.removeWhere((event) {
              //   String from = event.from.split(' ')[0];
              //   String to = event.to.split(' ')[0];
              //   if (
              // });

              // if (dayEvents.isEmpty) {
              //   return const Center(
              //     child: Text(
              //       'No Events found!',
              //       style: TextStyle(
              //         fontSize: 24
              //       )
              //     )
              //   );
              // } else {
                return SfCalendar(
                  view: CalendarView.timelineDay,
                  // view: CalendarView.timelineWeek,
                  dataSource: EventDataSource(dayEvents),
                  initialDisplayDate: widget.currDate.add(const Duration(hours: 8)),
                  timeSlotViewSettings: const TimeSlotViewSettings(
                    // nonWorkingDays: [DateTime.sunday, DateTime.saturday],
                    timelineAppointmentHeight: 70
                    // numberOfDaysInView: 2,

                  ),
                  appointmentBuilder: appointmentBuilder,
                  todayHighlightColor: Colors.black,
                  headerHeight: 0,
                  onTap: (details) {
                    if (details.appointments == null) return;
                    // final event = details.appointments!.first;
                    //navigate to view event
                  },
                );
              // }
            } else {
              return const CircularProgressIndicator();
            }

          default: return const CircularProgressIndicator();
        }
      }
    );

    /*

    if (dayEvents.isEmpty) {
      return const Center(
        child: Text(
          'No Events found!',
          style: TextStyle(
            fontSize: 24
          )
        )
      );
    }

    return SfCalendar(
      view: CalendarView.timelineDay,
      //datasource: EventDataSource
      //initialDisplayDate: provider.selectedDate,
      appointmentBuilder: appointmentBuilder,
      todayHighlightColor: Colors.black,
      headerHeight: 0,
      onTap: (details) {
        if (details.appointments == null) return;
        final event = details.appointments!.first;
        //navigate to view event
      },
    );
    // return SfCalendarTheme
    */


  }
}