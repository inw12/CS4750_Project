import 'package:intl/intl.dart';

class Utils {
  static String toDateTime(DateTime dateTime) {
    final date = DateFormat.yMMMEd().format(dateTime);
    final time = DateFormat.Hm().format(dateTime);

    return '$date $time';
  }

  // "12/12/2000"
  static String toDate(DateTime dateTime) {
    final date = DateFormat.yMd().format(dateTime);
    return date;
  }

  // "December 12, 2000"
  static String toDate2(DateTime dateTime) {
    final date = DateFormat.yMMMMd().format(dateTime);
    return date;
  }

  // "10:00 AM"
  static String toTime(DateTime dateTime) {
    final time = DateFormat.jm().format(dateTime);
    return time;
  }

  static String toDayOfWeek(DateTime dateTime) {
    final List<String> weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    String day = weekdays[dateTime.weekday - 1];
    return day;
  }
}