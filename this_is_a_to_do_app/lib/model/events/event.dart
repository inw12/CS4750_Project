
// *-----*  EVENT CLASS  *----------------------------------------------------*

import 'dart:ui';
import '../../assets/colors.dart';

class Event {
  String id;
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final Color color;

  Event({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    this.color = AppColors.primary,
  });

  factory Event.fromMap(Map<dynamic, dynamic> data, String id) {
    return Event(
      id: id,
      title: data['title'] ?? 'Untitled',
      startDate: DateTime.fromMillisecondsSinceEpoch(data['startDate']),
      endDate: DateTime.fromMillisecondsSinceEpoch(data['endDate']),
      color: AppColors.primary,
    );
  }
}
