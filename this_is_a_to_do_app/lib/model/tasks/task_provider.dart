
// *-----*  LIST OF TASKS  *--------------------------------------------------*

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'task.dart';
import 'package:firebase_database/firebase_database.dart';

class TaskProvider with ChangeNotifier {
  final _database = FirebaseDatabase.instance.ref();
  final uid = FirebaseAuth.instance.currentUser?.uid;

  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  Future<void> fetchTasks() async {
    final snapshot = await _database.child("users/$uid/tasks").get();

    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      _tasks = data.entries.map((entry) {
        return Task.fromMap(entry.value, entry.key);
      }).toList();
      notifyListeners();
    }
  }

  void clearTasks() {
    _tasks = [];
    notifyListeners();
  }

  void addTask(Task task) {
    String id = task.id;
    try {
      _database.child("users/$uid/tasks/$id").set({
        "id": task.id,
        "title": task.title,
        "isDone": task.isDone,
        "isHighPriority": task.isHighPriority,
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error writing task");
        print(e.toString());
      }
    }
    _tasks.add(task);
    notifyListeners();
  }

  void deleteTask(Task task) {
    String id = task.id;
    _database.child("users/$uid/tasks/$id").remove();
    _tasks.remove(task);
    notifyListeners();
  }

  void editTask(Task newTask, Task oldTask) {
    String id = oldTask.id;
    _database.child("users/$uid/tasks/$id").update({
      "title": newTask.title,
      "isDone": newTask.isDone,
      "isHighPriority": newTask.isHighPriority
    });

    final index = _tasks.indexOf(oldTask);
    _tasks[index] = newTask;
    notifyListeners();
  }

  void togglePriority(Task task) {
    String id = task.id;
    _database.child("users/$uid/tasks/$id").update({
      "isHighPriority": !task.isHighPriority,
    });
    task.isHighPriority = !task.isHighPriority;
    notifyListeners();
  }

  void toggleCompletion(Task task) {
    String id = task.id;
    _database.child("users/$uid/tasks/$id").update({
      "isDone": !task.isDone,
    });
    task.isDone = !task.isDone;
    notifyListeners();
  }
}