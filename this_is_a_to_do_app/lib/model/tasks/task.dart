
// *-----*  TASK CLASS  *-----------------------------------------------------*

class Task {
  String id;
  String? title;
  bool isHighPriority;
  bool isDone;

  Task({
    required this.id,
    required this.title,
    this.isHighPriority = false,
    this.isDone = false,
  });

  factory Task.fromMap(Map<dynamic, dynamic> data, String id) {
    return Task(
      id: id,
      title: data['title'],
      isDone: data['isDone'],
      isHighPriority: data['isHighPriority'],
    );
  }
}
