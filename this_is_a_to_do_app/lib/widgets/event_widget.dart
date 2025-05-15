import 'package:flutter/material.dart';
import '../assets/colors.dart';
import '../helper/utils.dart';
import '../model/events/event.dart';

class EventWidget extends StatefulWidget {
  final Event event;
  const EventWidget({super.key, required this.event});

  @override
  State<EventWidget> createState() => _EventWidgetState();
}

class _EventWidgetState extends State<EventWidget> {


  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      tileColor: AppColors.item,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 7,
      ),
      leading: Icon(Icons.calendar_month, color: AppColors.primary),
      title: Text(
        widget.event.title,
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      subtitle: Text(
        "${Utils.toTime(widget.event.startDate)} - ${Utils.toTime(widget.event.endDate)}",
        style: TextStyle(
          color: Colors.white54,
        ),
      ),
    );
  }
}
