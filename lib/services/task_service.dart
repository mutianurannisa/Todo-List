import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = 'tasks';

  Stream<List<Task>> getTasks() {
    return _firestore
        .collection(collectionName)
        .orderBy('date')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Task.fromJson(doc.data()..['id'] = doc.id)).toList());
  }

  Future<void> addTask(Task task) async {
    await _firestore.collection(collectionName).doc(task.id).set(task.toJson());
  }

  Future<void> updateTask(Task task) async {
    await _firestore.collection(collectionName).doc(task.id).update(task.toJson());
  }

  Future<void> deleteTask(String id) async {
    await _firestore.collection(collectionName).doc(id).delete();
  }
}
