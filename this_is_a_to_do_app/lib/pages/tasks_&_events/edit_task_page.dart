import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../assets/colors.dart';
import '../../model/tasks/task.dart';
import '../../model/tasks/task_provider.dart';

class EditTaskPage extends StatefulWidget {
  final Task? task;
  const EditTaskPage({super.key, this.task});

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  late bool isHighPriority;
  late bool isDone;

  @override
  void initState() {
    super.initState();
    if (widget.task == null) {
      isHighPriority = false;
      isDone = false;
    } else {
      final task = widget.task!;
      titleController.text = task.title!;
      isHighPriority = task.isHighPriority;
      isDone = task.isDone;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  void _toggleButton() {
    setState(() {
      isHighPriority = !isHighPriority;
    });
  }


  // *-----*  MAIN CONTENT *--------------------------------------------------*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: CloseButton(color: Colors.white),
        actions: buildEditingActions(),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              buildTitle(titleController),
              SizedBox(height: 24),
              buildPriorityPickers(),
            ],
          ),
        ),
      ),
    );
  }
  // *------------------------------------------------------ end of MAIN -----*


  Widget buildTitle(dynamic titleController) => TextFormField(
    style: TextStyle(color: AppColors.white, fontSize: 24),
    decoration: InputDecoration(
      border: UnderlineInputBorder(),
      hintText: "Enter Task",
      hintStyle: TextStyle(color: Colors.white60),
    ),
    onFieldSubmitted: (_) => saveForm(),
    validator:
        (title) =>
            title != null && title.isEmpty ? 'Task name cannot be empty' : null,
    controller: titleController,
  );

  List<Widget> buildEditingActions() => [
    ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        foregroundColor: AppColors.primary,
        backgroundColor: AppColors.secondaryBackground,
        shadowColor: AppColors.transparent,
      ),
      icon: Icon(Icons.done),
      label: Text("Create"),
      onPressed: saveForm,
    ),
  ];

  Widget buildPriorityPickers() => Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        'Priority',
        style: TextStyle(
          color: AppColors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),

      SizedBox(height: 10),

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Default Priority Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isHighPriority ? AppColors.background : Colors.green,
              foregroundColor: Colors.white,
              minimumSize: Size(150, 50),
              side: BorderSide(color: Colors.green, width: 2),
            ),
            onPressed: () {
              if (isHighPriority) {
                _toggleButton();
              }
            },
            child: Text(
              'Default',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
          ),

          // High Priority Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isHighPriority ? Colors.red : AppColors.background,
              foregroundColor: Colors.white,
              minimumSize: Size(150, 50),
              side: BorderSide(color: Colors.red, width: 2),
            ),
            onPressed: () {
              if (!isHighPriority) {
                _toggleButton();
              }
            },
            child: Text(
              'High',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    ],
  );

  Future saveForm() async {
    final isValid = _formKey.currentState!.validate();

    // "if everything is valid..."
    if (isValid) {
      final provider = Provider.of<TaskProvider>(context, listen: false);
      final isEditing = widget.task != null;
      var timestamp = DateTime.now().millisecondsSinceEpoch;

      final task = Task(
        id: isEditing ? widget.task!.id : "task$timestamp", // task id
        title: titleController.text, // task title
        isHighPriority: isHighPriority, // priority check
        isDone: isDone, // completion check
      );

      if (isEditing) {
        provider.editTask(task, widget.task!);
      } else {
        provider.addTask(task);
      }

      Navigator.of(context).pop();
    }
  }
}
