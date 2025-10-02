import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:listflutter/models/task.dart';

class FirestoreService {
  final CollectionReference tasksCollection = FirebaseFirestore.instance
      .collection('tasks');
  Future<void> addTask(Task task) {
    return tasksCollection.add(task.ToFirestore());
  }

  Stream<List<Task>> getTasks() {
    return tasksCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Task.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }
  Future<void> updateTaskStatus(String id, bool isCompleted) {
    return tasksCollection.doc(id).update({'isCompleted': isCompleted});
  }
  Future<void> deleteTask(String id) {
    return tasksCollection.doc(id).delete();
  }
}
