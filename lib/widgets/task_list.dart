import 'package:flutter/material.dart';
import '../models/task_model.dart';
import 'task_item.dart';

class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final Function(Task) onEdit;
  final Function(Task) onDelete;
  final ValueChanged<bool?> onToggleComplete; 

  const TaskList({
    super.key,
    required this.tasks,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleComplete, 
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const Center(
        child: Text(
          'Belum ada tugas 😶',
          style: TextStyle(color: Colors.white54),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskItem(
          task: task,
          onEdit: () => onEdit(task),
          onDelete: () => onDelete(task),
          onToggleComplete: (value) { 
            onToggleComplete(value); 
          },
        );
      },
    );
  }
}