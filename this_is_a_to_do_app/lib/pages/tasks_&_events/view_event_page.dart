import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../assets/colors.dart';
import '../../helper/utils.dart';
import '../../model/events/event.dart';
import '../../model/events/event_provider.dart';
import 'edit_event_page.dart';

class ViewEventPage extends StatelessWidget {
  final Event event;

  const ViewEventPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: buildAppBar(context),
      body: buildEventDetails(),
    );
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.secondaryBackground,
      leading: CloseButton(color: Colors.white),
      actions: buildViewingActions(context, event),
    );
  }

  List<Widget> buildViewingActions(BuildContext context, Event event) => [
    // Edit Button
    IconButton(
      onPressed:
          () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => EditEventPage(event: event)),
          ),
      icon: Icon(Icons.edit),
      color: Colors.white,
    ),

    // Delete Button
    IconButton(
      onPressed: () {
        final provider = Provider.of<EventProvider>(context, listen: false);
        provider.deleteEvent(event);
        Navigator.of(context).pop();
      },
      icon: Icon(Icons.delete),
      color: Colors.red,
    ),
  ];

  Widget buildEventDetails() {
    return ListView(
      padding: EdgeInsets.all(32),
      children: <Widget>[
        // Event Title
        Text(
            event.title,
            style: TextStyle(
              color: AppColors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            )
        ),

        const SizedBox(height: 12),

        // Event Start/End Times
        Text(
          "${Utils.toDayOfWeek(event.startDate)}, ${Utils.toDate2(event.startDate)}\n"
              "${Utils.toTime(event.startDate)} - ${Utils.toTime(event.endDate)}",
          style: TextStyle(color: Colors.white60),
        ),
      ],
    );
  }
}
