import 'dart:ui';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'event.dart';

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Event> appointments) {
    this.appointments = appointments;
  }

  // Getters
  Event getEvent(int index) => appointments![index] as Event;
  @override
  DateTime getStartTime(int index) => getEvent(index).startDate;
  @override
  DateTime getEndTime(int index) => getEvent(index).endDate;
  @override
  String getSubject(int index) => getEvent(index).title;
  @override
  Color getColor(int index) => getEvent(index).color;
}