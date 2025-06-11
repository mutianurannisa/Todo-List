import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import '../models/task_model.dart';
import '../widgets/task_item.dart';
import '../widgets/task_form.dart';
import '../screens/settings_screen.dart';
import '../screens/calendar_screen.dart';
import '../providers/task_provider.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CalendarScreen()),
            );
          },
        ),
        title: const Text(
        'Todo-List',
          style: TextStyle(
          fontFamily: 'jomhuria', 
          fontSize: 60, 
          ),
        ),
        
        centerTitle: true,
        titleSpacing: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search for your task...',
                hintStyle: TextStyle(color: Theme.of(context).hintColor),
                prefixIcon: Icon(Icons.search, color: Theme.of(context).iconTheme.color),
                filled: true,
                fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                border: Theme.of(context).inputDecorationTheme.border,
                enabledBorder: Theme.of(context).inputDecorationTheme.border,
                focusedBorder: Theme.of(context).inputDecorationTheme.border,
              ),
              style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer<TaskProvider>(
                builder: (context, taskProvider, child) {
                  if (taskProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (taskProvider.errorMessage != null) {
                    return Center(child: Text('Error: ${taskProvider.errorMessage!}'));
                  }
                  if (taskProvider.tasks.isEmpty) {
                    return const Center(child: Text('Tidak ada task. Tambahkan satu!'));
                  }

                  final allTasks = taskProvider.tasks; // Ambil semua task dari provider
                  final filteredTasks = allTasks.where((task) {
                    final title = task.title.toLowerCase();
                    final description = task.description.toLowerCase();
                    return title.contains(searchQuery) || description.contains(searchQuery);
                  }).toList();

                  final incompleteTasks = filteredTasks.where((t) => !t.isCompleted).toList();
                  final completedTasks = filteredTasks.where((t) => t.isCompleted).toList();

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Incomplete',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        if (incompleteTasks.isEmpty)
                          Text(
                            'Tidak ada task yang belum selesai.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          )
                        else
                          ...incompleteTasks.map((task) => TaskItem(
                            task: task,
                            onDelete: () async {
                              await taskProvider.deleteTask(task.id); 
                            },
                            onEdit: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TaskForm(
                                    task: task,
                                    onSave: (updatedTask) async {
                                      await taskProvider.updateTask(updatedTask); 
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              );
                            },
                            onToggleComplete: (bool? value) async {
                              if (value != null) {
                                task.isCompleted = value;
                                await taskProvider.updateTask(task); 
                              }
                            },
                          )),
                        const SizedBox(height: 24),
                        Text(
                          'Completed',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        if (completedTasks.isEmpty)
                          Text(
                            'Tidak ada task selesai.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          )
                        else
                          ...completedTasks.map((task) => TaskItem(
                            task: task,
                            onDelete: () async {
                              await taskProvider.deleteTask(task.id); 
                            },
                            onEdit: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TaskForm(
                                    task: task,
                                    onSave: (updatedTask) async {
                                      await taskProvider.updateTask(updatedTask); 
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              );
                            },
                            onToggleComplete: (bool? value) async {
                              if (value != null) {
                                task.isCompleted = value;
                                await taskProvider.updateTask(task); 
                              }
                            },
                          )),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskForm(
                onSave: (newTask) async {
                  final taskProvider = Provider.of<TaskProvider>(context, listen: false);
                  await taskProvider.addTask(newTask);
                },
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}