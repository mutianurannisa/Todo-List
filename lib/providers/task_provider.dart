import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/task_model.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _errorMessage;
  User? _currentUser;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _currentUser;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  TaskProvider() {
    _auth.authStateChanges().listen((user) {
      _currentUser = user;
      if (user != null) {
        _fetchTasks();
      } else {
        _tasks = [];
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      }
    });
  }

  void _fetchTasks() {
    if (_currentUser == null) {
      _errorMessage = "User not logged in.";
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    _firestore
        .collection('users')
        .doc(_currentUser!.uid)
        .collection('tasks')
        .orderBy('deadline', descending: false)
        .snapshots()
        .listen((snapshot) {
      _tasks = snapshot.docs.map((doc) {
        return Task.fromJson(doc.data()..['id'] = doc.id);
      }).toList();
      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
    }, onError: (error) {
      _errorMessage = "Failed to fetch tasks: $error";
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> addTask(Task task) async {
    if (_currentUser == null) {
      _errorMessage = "User not logged in.";
      notifyListeners();
      return;
    }
    _isLoading = true;
    notifyListeners();
    try {
      await _firestore
          .collection('users')
          .doc(_currentUser!.uid)
          .collection('tasks')
          .add(task.toJson());
      _isLoading = false;
    } catch (e) {
      print("Error adding task: $e");
      _errorMessage = "Failed to add task: $e";
      _isLoading = false;
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateTask(Task task) async {
    if (_currentUser == null) {
      _errorMessage = "User not logged in.";
      notifyListeners();
      return;
    }
    _isLoading = true;
    notifyListeners();
    try {
      await _firestore
          .collection('users')
          .doc(_currentUser!.uid)
          .collection('tasks')
          .doc(task.id)
          .update(task.toJson());
      _isLoading = false;
    } catch (e) {
      print("Error updating task: $e");
      _errorMessage = "Failed to update task: $e";
      _isLoading = false;
    } finally {
      notifyListeners();
    }
  }

  Future<void> deleteTask(String taskId) async {
    if (_currentUser == null) {
      _errorMessage = "User not logged in.";
      notifyListeners();
      return;
    }
    _isLoading = true;
    notifyListeners();
    try {
      await _firestore
          .collection('users')
          .doc(_currentUser!.uid)
          .collection('tasks')
          .doc(taskId)
          .delete();
      _isLoading = false;
    } catch (e) {
      print("Error deleting task: $e");
      _errorMessage = "Failed to delete task: $e";
      _isLoading = false;
    } finally {
      notifyListeners();
    }
  }

  void setUser(User? user) {
    if (user != null) {
      if (_currentUser == null || _currentUser!.uid != user.uid) {
        _currentUser = user;
        _fetchTasks();
      }
    } else {
      _currentUser = null;
      _tasks = [];
      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
    }
  }

  int get completedTasksCount {
    return _tasks.where((task) => task.isCompleted).length;
  }

  int get pendingTasksCount {
    return _tasks.where((task) => !task.isCompleted).length;
  }

  List<Task> getIncompleteTasksForDate(DateTime date) {
    return _tasks.where((task) {
      return task.deadline != null &&
             !task.isCompleted && 
             task.deadline!.year == date.year &&
             task.deadline!.month == date.month &&
             task.deadline!.day == date.day;
    }).toList();
  }
}