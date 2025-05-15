import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../assets/colors.dart';
import '../../model/events/event.dart';
import '../../model/events/event_provider.dart';
import '../../model/tasks/task.dart';
import '../../model/tasks/task_provider.dart';
import '../../widgets/event_widget.dart';
import '../../widgets/task_widget.dart';
import '../tasks_&_events/view_event_page.dart';

class TodayPage extends StatefulWidget {
  const TodayPage({super.key});

  @override
  State<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final DateTime startOfToday = DateTime(now.year, now.month, now.day);
    final DateTime endOfToday = startOfToday.add(Duration(days: 1));

    // *---*  TASKS  *--------------------------------*
    final tasks = Provider.of<TaskProvider>(context);
    final taskList =
        tasks.tasks.length > 4
            ? tasks.tasks.sublist(0, 4).where((task) => !task.isDone && task.isHighPriority).toList()
            : tasks.tasks.where((task) => !task.isDone && task.isHighPriority).toList();
    // Sort tasks by incomplete first, then alphabetical
    taskList.sort((a, b) {
      if (a.isDone != b.isDone) {
        return a.isDone ? 1 : -1;
      }
      return a.title!.toLowerCase().compareTo(b.title!.toLowerCase());
    });

    // *---*  EVENTS  *-------------------------------*
    final events = Provider.of<EventProvider>(context);
    final eventList = events.eventsOfSelectedDate;
    // filter by events happening today
    final upcomingEvents =
        eventList
            .where(
              (date) =>
                  (date.startDate.isAfter(DateTime.now()) || date.endDate.isAfter(DateTime.now())) &&
                  (date.startDate.isAfter(startOfToday) && date.endDate.isBefore(endOfToday)),
            )
            .toList();
    // sort tasks_&_events by start date
    upcomingEvents.sort((a, b) => a.startDate.compareTo(b.startDate));


    return MaterialApp(
      theme: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),

      home: Scaffold(
        backgroundColor: AppColors.background,

        appBar: buildAppBar(),

        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildTaskHeader("Tasks"),
            Expanded(flex: 4, child: buildTaskList(taskList, tasks)),

            buildEventHeader("Upcoming Event"),
            buildCalendarEvent(upcomingEvents),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // *---*  WIDGETS  *--------------------------------------------------------*
  PreferredSizeWidget buildAppBar() {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // "TODAY"
          SizedBox(height: 25),
          Text(
            'Today',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),

          // TODAY'S DATE
          SizedBox(height: 5),
          Text(
            DateFormat('MMMM dd, yyyy').format(DateTime.now()),
            style: TextStyle(
              color: Color(0xffC78D28),
              fontSize: 20,
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
      backgroundColor: AppColors.background,
      centerTitle: true,
      toolbarHeight: 120,
    );
  }

  Widget buildTaskList(List<Task> taskList, TaskProvider provider) {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(), // android-style scrolling physics
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (Task task in taskList)
            TaskWidget(
              task: task,
              toggleCompletion: (_) => provider.toggleCompletion(task),
              togglePriority: (_) => provider.togglePriority(task),
            ),
        ],
      ),
    );
  }

  Widget buildCalendarEvent(List<Event> eventList) {
    if (eventList.isNotEmpty) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: GestureDetector(
          onTap: () {
            if (eventList.isNotEmpty) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ViewEventPage(event: eventList[0]),
                ),
              );
            }
          },
          child: Column(
            children: [
              const SizedBox(height: 10),
              EventWidget(event: eventList[0]),
            ],
          ),
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 10),
            ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              tileColor: AppColors.item,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
              leading: Text(
                "Nothing today...",
                style: TextStyle(
                  color: Colors.white70,
                  fontStyle: FontStyle.italic,
                  fontSize: 16,
                  fontWeight: FontWeight.w400
                ),
              ),
              title: Text("", style: TextStyle(fontSize: 20, color: Colors.white)),
              subtitle: Text("", style: TextStyle(color: Colors.white54)),
            ),
          ],
        ),
      );
    }
  }

  Widget buildTaskHeader(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white60,
          ),
        ),
      ),
    );
  }

  Widget buildEventHeader(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white60,
          ),
        ),
      ),
    );
  }
}
