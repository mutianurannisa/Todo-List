import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final ValueChanged<bool?> onToggleComplete; 

  const TaskItem({
    super.key,
    required this.task,
    required this.onDelete,
    required this.onEdit,
    required this.onToggleComplete, 
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      color: task.isCompleted
          ? (isDark ? const Color(0xFF2A2A2E) : const Color(0xFFF1E4FE)) 
          : (isDark ? const Color(0xFF1F1F23) : const Color(0xFFFDF9FF)), 
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            Checkbox(
              value: task.isCompleted,
              onChanged: onToggleComplete, 
              activeColor: const Color(0xFF00C853), 
            ),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      color: theme.textTheme.titleLarge?.color,
                      fontWeight: FontWeight.bold,
                      decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    task.description,
                    style: TextStyle(
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                  ),
                  const SizedBox(height: 4),

                  if (task.deadline != null)
                    Text(
                      'Deadline: ${task.deadline!.toLocal().toString().split(" ")[0]} ${TimeOfDay.fromDateTime(task.deadline!).format(context)}',
                      style: TextStyle(fontSize: 12, color: theme.textTheme.bodyMedium?.color),
                    ),

                  if (task.category != null && task.category!.isNotEmpty)
                    Text(
                      'Kategori: ${task.category}',
                      style: TextStyle(fontSize: 12, color: isDark ? const Color(0xFFFFA4FD) : const Color(0xFFB74FBF)),
                    ),
                ],
              ),
            ),

            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.edit,
                      color: theme.colorScheme.primary.withOpacity(0.8), size: 20),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: Icon(Icons.delete,
                      color: Colors.redAccent.shade200, size: 20),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}