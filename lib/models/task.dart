import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String? id;
  String title;
  bool isCompleted;

  Task({this.id, required this.title, this.isCompleted = false});

  factory Task.fromFirestore(Map<String, dynamic> data, String id) {
    return Task(
      id: id,
      title: data['title'] ?? '',
      isCompleted: data['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> ToFirestore() {
    return {
      'title': title,
      'isCompleted': isCompleted,
    };
  }
}
