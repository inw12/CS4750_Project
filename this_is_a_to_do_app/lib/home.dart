import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:this_is_a_to_do_app/pages/main/calendar_page.dart';
import 'package:this_is_a_to_do_app/pages/main/profile_page.dart';
import 'package:this_is_a_to_do_app/pages/main/tasks_page.dart';
import 'package:this_is_a_to_do_app/pages/main/today_page.dart';
import 'assets/colors.dart';
import 'model/events/event_provider.dart';
import 'model/tasks/task_provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<void> _initialLoad;

  // List of all pages
  int pageIndex = 0;
  final List<Widget> _pages = [
    TodayPage(),
    TaskPage(),
    CalendarPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final eventProvider = Provider.of<EventProvider>(context, listen: false);

    taskProvider.clearTasks();
    eventProvider.clearTasks();

    _initialLoad = Future.wait([
      taskProvider.fetchTasks(),
      eventProvider.fetchEvents(),
    ]);
  }

  // Updates page index based on which item tapped
  void _onItemTapped(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  // *---*  MAIN  *-----------------------------------------------------------*
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialLoad,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return MaterialApp(
          theme: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
          ),
          home: Scaffold(
            backgroundColor: AppColors.background,
            body: _pages[pageIndex],
            bottomNavigationBar: _buildBottomNavBar(),
          ),
        );
      },
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      // - Appearance
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.secondaryBackground,
      unselectedItemColor: Colors.white,
      selectedItemColor: AppColors.primary,
      // - Behavior
      currentIndex: pageIndex, // set current index
      onTap: _onItemTapped, // change index when item is pressed
      // - Page List
      items: [
        // *---* TODAY *---*
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled),
          label: 'Home',
        ),
        // *---* TASKS *---*
        BottomNavigationBarItem(
          icon: Icon(Icons.format_list_bulleted),
          label: 'Tasks',
        ),
        // *---* CALENDAR *---*
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month),
          label: 'Calendar',
        ),
        // *---* SETTINGS *---*
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }

}
