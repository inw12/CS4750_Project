import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../assets/colors.dart';
import '../model/tasks/task.dart';
import '../model/tasks/task_provider.dart';
import '../pages/tasks_&_events/edit_task_page.dart';

class TaskWidget extends StatefulWidget {
  final Task task;
  final dynamic toggleCompletion;
  final dynamic togglePriority;
  const TaskWidget({super.key, required this.task, required this.toggleCompletion, this.togglePriority});

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 70,
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                TaskWidget tmp = widget;
                tmp.toggleCompletion(tmp);
                _buildSnackBar(tmp);
              },
              onLongPress: () {
                showModalBottomSheet(
                    context: context,
                    backgroundColor: Color(0xff242435),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular((16)))
                    ),
                    builder: (context) {
                      return Container(
                        padding: EdgeInsets.all(16),
                        child: Wrap(
                          children: [
                            ListTile(
                              leading: Icon(
                                  widget.task.isHighPriority ? Icons.star_border : Icons.star,
                                  color: Colors.yellow
                              ),
                              title: Text(
                                widget.task.isHighPriority ? 'De-Prioritize' : 'Prioritize',
                                style: TextStyle(color: AppColors.white),
                              ),
                              onTap: () {
                                widget.togglePriority(widget.task);
                                Navigator.of(context).pop();
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.edit, color: AppColors.white),
                              title: Text(
                                'Edit',
                                style: TextStyle(color: AppColors.white),
                              ),
                              onTap: () => Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) => EditTaskPage(task: widget.task)),
                              ),
                            ),
                            ListTile(
                              leading: Icon(Icons.delete, color: Colors.red),
                              title: Text(
                                'Delete',
                                style: TextStyle(color: Colors.redAccent),
                              ),
                              onTap: () {
                                final provider = Provider.of<TaskProvider>(context, listen: false);
                                provider.deleteTask(widget.task);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        )

                      );
                    }
                );
              },

              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                tileColor: widget.task.isDone ? AppColors.invalidItem : AppColors.item,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 4,
                ),

                leading:
                    widget.task.isDone
                        ? Icon(Icons.check_circle, color: AppColors.secondary)
                        : Icon(
                          Icons.circle_outlined,
                          color: AppColors.primary,
                        ),

                title: Text(
                  widget.task.title!,
                  style: TextStyle(
                    fontSize: 20,
                    color:
                        widget.task.isDone ? AppColors.invalidText : AppColors.text,
                    decoration:
                        widget.task.isDone
                            ? TextDecoration.lineThrough
                            : null,
                    decorationColor: AppColors.invalidText,
                    decorationThickness: 2.5,
                  ),
                ),

                trailing: Icon(
                  widget.task.isHighPriority
                      ? Icons.star
                      : Icons.done,
                  color:
                      widget.task.isHighPriority
                          ? Colors.yellow
                          : Colors.transparent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _buildSnackBar(TaskWidget tmp) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          tmp.task.isDone ? 'Completed!' : 'Marked as Incomplete',
        ),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            tmp.toggleCompletion(tmp);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Undo successful')),
            );
          },
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
