import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../assets/colors.dart';
import '../model/events/event_data_source.dart';
import '../model/events/event_provider.dart';
import '../pages/tasks_&_events/view_event_page.dart';


class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context);

    return SfCalendar(
      // *-----*  FUNCTIONALITY  *--------------------------------------------*
      view: CalendarView.month,
      initialSelectedDate: DateTime.now(),
      initialDisplayDate: DateTime.now(),
      showTodayButton: true,
      showDatePickerButton: false,
      showNavigationArrow: true,
      dataSource: EventDataSource(provider.events),
      onTap: (details) {
        if (details.targetElement == CalendarElement.appointment && details.date != null) {
          final event = details.appointments!.first;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ViewEventPage(event: event),
            ),
          );
        }
      },
      // *----------------------------------------- end of FUNCTIONALITY -----*


      // *-----*  APPEARANCE  *-----------------------------------------------*
      backgroundColor: Colors.transparent, // background color
      cellBorderColor: Colors.white38, // cell border color
      // ---< Header >---
      headerHeight: 110,
      headerDateFormat: '',
      headerStyle: CalendarHeaderStyle(
        textAlign: TextAlign.center,
        backgroundColor: AppColors.background,
        textStyle: TextStyle(
          color: AppColors.white,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),

      // ---< View Header >---
      viewHeaderHeight: 25,
      viewHeaderStyle: ViewHeaderStyle(
        backgroundColor: AppColors.background,
        dayTextStyle: TextStyle(color: Colors.white),
        dateTextStyle: TextStyle(color: Colors.transparent),
      ),

      // ---< Body >---
      monthViewSettings: MonthViewSettings(
        showTrailingAndLeadingDates: true,
        showAgenda: true,
        appointmentDisplayMode:
            MonthAppointmentDisplayMode
                .indicator, // event indicators on calendar cells
        // - Cell Colors
        monthCellStyle: MonthCellStyle(
          // text color
          textStyle: TextStyle(color: Colors.white),
          trailingDatesTextStyle: TextStyle(color: Colors.white54),
          leadingDatesTextStyle: TextStyle(color: Colors.white54),
          // cell colors
          backgroundColor: AppColors.background,
          todayBackgroundColor: AppColors.background,
          trailingDatesBackgroundColor: AppColors.secondaryBackground,
          leadingDatesBackgroundColor: AppColors.secondaryBackground,
        ),

        // - Agenda Appearance
        agendaStyle: AgendaStyle(
          backgroundColor: AppColors.background,
          appointmentTextStyle: TextStyle(color: AppColors.white),
          dayTextStyle: TextStyle(color: AppColors.white),
          dateTextStyle: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),

      // ---< Cell Selection >---
      todayHighlightColor: Colors.transparent,
      todayTextStyle: TextStyle(
        color: AppColors.primary,
        fontWeight: FontWeight.bold,
      ),
      selectionDecoration: BoxDecoration(
        color: Colors.transparent, // fill color
        border: Border.all(
          // border color
          color: AppColors.primary,
        ),
        shape: BoxShape.rectangle, // selection shape
      ),

      // *-------------------------------------------- end of APPEARANCE -----*
    );
  }
}
