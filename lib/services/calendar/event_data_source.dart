import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../cloud/events/cloud_event.dart';

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<CloudEvent> appointments) {
    this.appointments = appointments;
  }

  CloudEvent getEvent(int index) {
    return appointments![index] as CloudEvent;
  }

  @override
  DateTime getStartTime(int index) {
    return DateTime.parse(getEvent(index).from);
  } 

  @override
  DateTime getEndTime(int index) {
    return DateTime.parse(getEvent(index).to);
  }

  @override
  String getSubject(int index) => getEvent(index).title;

  @override
  bool isAllDay(int index) {
    int boolean = getEvent(index).isAllDay;
    return boolean == 1;
  }
}