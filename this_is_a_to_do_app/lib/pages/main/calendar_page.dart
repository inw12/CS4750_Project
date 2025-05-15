import 'package:flutter/material.dart';
import '../../assets/colors.dart';
import '../../widgets/calendar_widget.dart';
import '../tasks_&_events/edit_event_page.dart';

class CalendarPage extends StatelessWidget {
  CalendarPage({super.key});

  final String currentYear = DateTime.now().year.toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CalendarWidget(),
      floatingActionButton: buildButton(context),
    );
  }

  Widget buildButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AppColors.primary,
      shape: CircleBorder(),
      elevation: 10,
      onPressed:
          () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => EditEventPage())),
      child: Icon(Icons.add, color: Colors.white),
    );
  }
}
