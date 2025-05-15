import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../assets/colors.dart';
import '../../model/tasks/task.dart';
import '../../model/tasks/task_provider.dart';
import '../../widgets/task_widget.dart';
import '../tasks_&_events/edit_task_page.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);
    final taskList = provider.tasks;

    taskList.sort((a, b) {
      if (a.isDone != b.isDone) return a.isDone ? 1 : -1;
      if (a.isHighPriority != b.isHighPriority) return a.isHighPriority ? -1 : 1;
      return a.title!.toLowerCase().compareTo(b.title!.toLowerCase());
    });

    return MaterialApp(
      theme: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),

      home: Scaffold(
        backgroundColor: AppColors.background, // Background Color
        appBar: buildAppBar(), // Header
        body: buildTaskList(taskList, provider), // Task List
        floatingActionButton: buildButton(context), // Add Task Button
      ),
    );
  }

  PreferredSizeWidget buildAppBar() {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 25),
          Text(
            'Tasks',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.background,
      centerTitle: true,
      toolbarHeight: 120,
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
      ).push(MaterialPageRoute(builder: (context) => EditTaskPage())),
      child: Icon(Icons.add, color: Colors.white),
    );
  }

  Widget buildTaskList(List<Task> taskList, TaskProvider provider) {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      padding: EdgeInsets.all(16),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 25),
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
}
