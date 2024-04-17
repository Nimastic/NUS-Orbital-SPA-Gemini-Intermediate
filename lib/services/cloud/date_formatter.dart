import 'package:intl/intl.dart';

class DateFormatter {

  static String toDateTime(DateTime dateTime) {
    final date = DateFormat.yMMMEd().format(dateTime);
    final time = DateFormat.Hm().format(dateTime);

    return '$date $time';
  }

  static String toDate(DateTime dateTime) {
    final date = DateFormat.yMMMEd().format(dateTime);

    return date; 
  }

  static String toTime(DateTime dateTime) {
    final time = DateFormat.Hm().format(dateTime);

    return time;
  }

  // static void toDateTimeType(String date) {
  //   int year = int.parse(date.split('-')[0]);
  //   int month = int.parse(date.split('-')[1].split('-')[0]);
  //   int day = int.parse(date.split('-')[1].split('-')[1].split(' ')[0]);
  //   int hour = int.parse(date.split('-')[1].split('-')[1].split(' ')[1].split(':')[0]);
  //   int minute = int.parse(date.split('-')[1].split('-')[1].split(' ')[1].split(':')[1].split(':')[0]);
  //   print(year);
  //   print(month);
  //   print(day);
  //   // return DateTime(year, month, day, hour, minute, 0);
  // }
}