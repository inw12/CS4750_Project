
// *-----*  LIST OF EVENTS  *-------------------------------------------------*

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'event.dart';

class EventProvider extends ChangeNotifier {
  final _database = FirebaseDatabase.instance.ref();
  final uid = FirebaseAuth.instance.currentUser?.uid;

  List<Event> _events = [];

  List<Event> get events => _events;

  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;
  List<Event> get eventsOfSelectedDate => _events;

  Future<void> fetchEvents() async {
    final snapshot = await _database.child("users/$uid/tasks_&_events").get();

    if (snapshot.exists) {
      try {
        final data = snapshot.value as Map<dynamic, dynamic>;
        _events = data.entries.map((entry) {
          return Event.fromMap(entry.value, entry.key);
        }).toList();
        notifyListeners();
      } catch (e) {
        if (kDebugMode) {
          print("Error parsing tasks_&_events: $e");
        }
      }
    }
  }

  void clearTasks() {
    _events = [];
    notifyListeners();
  }

  void setDate(DateTime date) => _selectedDate = date;

  void addEvent(Event event) {
    String id = event.id;
    try {
      _database.child("users/$uid/tasks_&_events/$id").set({
        "id": event.id,
        "title": event.title,
        "startDate": event.startDate.millisecondsSinceEpoch,
        "endDate": event.endDate.millisecondsSinceEpoch,
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error!");
        print(e.toString());
      }
    }
    _events.add(event);
    notifyListeners();  // Updates the UI
  }

  void deleteEvent(Event event) {
    String id = event.id;
    _database.child("users/$uid/tasks_&_events/$id").remove();
    _events.remove(event);
    notifyListeners();  // Updates the UI
  }

  void editEvent(Event newEvent, Event oldEvent) {
    String id = oldEvent.id;
    _database.child("users/$uid/tasks_&_events/$id").update({
      "title": newEvent.title,
      "startDate": newEvent.startDate.millisecondsSinceEpoch,
      "endDate": newEvent.endDate.millisecondsSinceEpoch,
    });
    final index = _events.indexOf(oldEvent);
    _events[index] = newEvent;
    notifyListeners();  // Updates the UI
  }
}