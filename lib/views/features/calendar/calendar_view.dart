import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:orbital_spa/constants/colours.dart';
import 'package:orbital_spa/constants/theme.dart';
import 'package:orbital_spa/services/calendar/event_data_source.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../../constants/images_strings.dart';
import '../../../services/auth/data/repositories/auth_repository.dart';
import '../../../services/cloud/events/cloud_event.dart';
import '../../../services/cloud/events/firebase_cloud_event_storage.dart';
import '../../../utilities/widgets/features/button.dart';
import 'add_event_view.dart';
import 'edit_event.dart';

class CalendarMonthView extends StatefulWidget {
  const CalendarMonthView({super.key});

  @override
  State<CalendarMonthView> createState() => _CalendarMonthViewState();
}

class _CalendarMonthViewState extends State<CalendarMonthView> {

  late final FirebaseCloudEventStorage _eventService;
  String get userId => AuthRepository.firebase().currentUser!.id;
  List<CloudEvent> events = [];
  List<CloudEvent> dayEvent = [];

  final CalendarController _controller = CalendarController();

  @override
  void initState() {
    super.initState();
    _eventService = FirebaseCloudEventStorage();
  }

  Widget _appointmentBuilder(
    BuildContext context,
    CalendarAppointmentDetails details
  ) {
    final event = details.appointments.first;

    if (_controller.view == CalendarView.month) {
      return _monthViewAppointment(event);
    } else if (_controller.view == CalendarView.timelineDay) {
      return _timelineViewAppointment(event);
    } else if (_controller.view == CalendarView.day) {
      return _dayViewAppointment(event);
    } else if (_controller.view == CalendarView.week) {
      return _weekViewAppointment(event);
    } else {
      return _scheduleWeekAppointment(event);
    } 
  }

  Widget _monthViewAppointment(CloudEvent event) {
    return GestureDetector(
      onTap: () {
        _showBottomSheet(
          context, 
          event
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: event.isAllDay == 0 ? [lightOrange, lightPink] : [lightPurple, lightPink]
          )
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 20),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),
                  ),
                  Text(
                    event.description,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[500]
                    ),
                  )
                ],
              ),
              const Spacer(),
              Visibility(
                visible: event.isAllDay == 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat.jm().format(DateTime.parse(event.from)),
                      style: const TextStyle(
                        fontFamily: 'GT Walsheim',
                        fontSize: 16
                      ),
                    ),
                    Text(
                      DateFormat.jm().format(DateTime.parse(event.to)),
                      style: TextStyle(
                        fontFamily: 'GT Walsheim',
                        color: Colors.grey[500],
                        fontSize: 15
                      ),
                    )
                  ],
                ),
              ),
              Visibility(
                visible: event.isAllDay == 1,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'All Day',
                      style: TextStyle(
                        fontFamily: 'GT Walsheim',
                        fontSize: 16
                      ),
                    ),
                  ],
                )
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _timelineViewAppointment(CloudEvent event) {
    bool isAllDay = event.isAllDay == 1;
    return Container(
      height: 70,
      padding: const EdgeInsets.only(top: 15, left: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient:  LinearGradient(
          begin: isAllDay ? Alignment.topCenter : Alignment.centerLeft,
          end: isAllDay ? Alignment.bottomCenter : Alignment.centerRight,
          colors: isAllDay ? [lightOrange, lightPink] : [lightPurple, lightPink]
        )
      ),
      child: Text(
        event.title,
        style: const TextStyle(
          fontFamily: 'GT Walsheim',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          overflow: TextOverflow.ellipsis
        ),
      )
    );
  }

  Widget _dayViewAppointment(CloudEvent event) {
    if (event.isAllDay == 0) {
      return Container(
        padding: const EdgeInsets.only(top: 3, left: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: const LinearGradient(
            colors: [lightOrange, lightPink]
          )
        ),
        child: Text(
          event.title,
          style: dayTitleTextStyle,
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            colors: [lightPurple, lightPink]
          )
        ),
        child: Text(
          event.title,
          style: dayAllDayTitleTextStyle,
        ),
      );
    }
  }

  Widget _weekViewAppointment(CloudEvent event) {
    if (event.isAllDay == 0) {
      return Container(
        padding: const EdgeInsets.only(top: 3, left: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [lightOrange, lightPink]
          )
        ),
        child: Text(
          event.title,
          style: weekTitleTextStyle,
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.only(left: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [lightPurple, lightPink]
          )
        ),
        child: Text(
          event.title,
          style: weekAllDayTitleTextStyle,
        ),
      );
    }
  }

  Widget _scheduleWeekAppointment(CloudEvent event) {
    if (event.isAllDay == 0) {
      return Container(
        padding: const EdgeInsets.only(top: 5, left: 8, right: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            colors: [lightOrange, lightPink]
          )
        ),
        child: Row(
          children: [
            Text(
              event.title,
              style: scheduleTitleTextStyle,
            ),
            const Spacer(),
            Visibility(
                visible: event.isAllDay == 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat.jm().format(DateTime.parse(event.from)),
                      style: scheduleFromDateTextStyle,
                    ),
                    Text(
                      DateFormat.jm().format(DateTime.parse(event.to)),
                      style: scheduleToDateTextStyle
                    )
                  ],
                ),
              ),
              
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.only(top: 4, left: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            colors: [lightPurple, lightPink]
          )
        ),
        child: Text(
          event.title,
          style: weekAllDayTitleTextStyle,
        ),
      );
    }
  }

  _showBottomSheet(BuildContext context, CloudEvent event) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        height: MediaQuery.of(context).size.height * 0.32,
        width: MediaQuery.of(context).size.width,
        color: background,
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
            _bottomSheetButton(
              label: "Edit Event", 
              onTap: () {
                Get.back();
                Get.to(() => EditEventView(event: event,));
              }, 
              clr: lightBlue,
              context: context
            ),
            // const SizedBox(height: 20),
            _bottomSheetButton(
              label: "Delete Event", 
              onTap: () {
                _eventService.deleteEvent(documentId: event.documentId);
                Get.back();
              }, 
              clr: lightPink,
              context: context
            ),
            const SizedBox(height: 20),
            _bottomSheetButton(
              label: "Close", 
              onTap: () {
                Get.back();
              }, 
              clr: lightPurple,
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
            style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    fontFamily: 'GT Walsheim'
                   ),
          )
        ),
      )
    );
  }

  void _calendarTapped(CalendarTapDetails calendarTapDetails) {
    // if (_controller.view == CalendarView.month && calendarTapDetails.targetElement == CalendarElement.calendarCell) {
    //   _controller.view = CalendarView.day;  
    // } else if ((_controller.view == CalendarView.week || 
    //       _controller.view == CalendarView.workWeek) && calendarTapDetails.targetElement == CalendarElement.viewHeader) {
    //   _controller.view = CalendarView.day;  
    // }
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
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(Icons.arrow_back_ios)
          ),
          title: Text(
            "Calendar",
            style: titleStyle
          ),
          centerTitle: true,
          backgroundColor: background,
        ),
        body: StreamBuilder(
          stream: _eventService.allEvents(ownerUserId: userId),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  events = snapshot.data!.toList();
                 
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      // color: Colors.pink[200]
                    ),
                    child: SfCalendar(
                      view: CalendarView.month,
    
                      allowedViews: const [
                        CalendarView.day,
                        CalendarView.week,
                        CalendarView.month,
                        CalendarView.timelineDay,
                        CalendarView.schedule
                      ],
                      controller: _controller,
    
                      dataSource: EventDataSource(events),
    
                      initialSelectedDate: DateTime.now(),
    
                      cellBorderColor: Colors.transparent,
    
                      monthViewSettings: const MonthViewSettings(
                        dayFormat: 'EEE',
                        showAgenda: true,
                        agendaItemHeight: 70,
                        agendaStyle: AgendaStyle(
                          // backgroundColor: background,
                          dayTextStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'GT Walsheim'
                          ),
                          dateTextStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'GT Walsheim'
                          ),
                        ),
                        monthCellStyle: MonthCellStyle(
                          todayBackgroundColor: lightGreen,
                          textStyle: TextStyle(
                            fontFamily: 'GT Walsheim',
                            fontSize: 18
                          ),
                        ),
                      ),
    
                      
    
                      appointmentBuilder: _appointmentBuilder,
    
                      timeSlotViewSettings: const TimeSlotViewSettings(
                        timelineAppointmentHeight: 80
                      ),
    
                      headerStyle: const CalendarHeaderStyle(
                        textAlign: TextAlign.start,
                        //backgroundColor: 
                        textStyle: TextStyle(
                          fontFamily: 'GT Walsheim',
                          fontWeight: FontWeight.bold,
                          fontSize: 22
                        )
                      ),
                      headerHeight: 70,
    
                      viewHeaderHeight: 70,
                      viewHeaderStyle: ViewHeaderStyle(
                        // backgroundColor:
                        dayTextStyle: headerTextStyle,
                        dateTextStyle: headerTextStyle
                      ),
                  
                      onTap: _calendarTapped,
    
                      allowViewNavigation: true,
                      showDatePickerButton: true,
                      showTodayButton: true,
                      viewNavigationMode: ViewNavigationMode.snap,
    
                      //scheduleViewMonthHeaderBuilder: ,
                    ),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              default: return const CircularProgressIndicator();
            }
          }
        ),
        floatingActionButton: MyButton(
          label: "+ Add Event", 
          onTap: () async {
            await Get.to(() => (const AddEventView()));
          },
          innerColour: lightPurple,
          borderColor: lightPurple,
          fontColor: black,
        ),
      ),
    );
  }
}