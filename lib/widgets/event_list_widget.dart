import 'package:flutter/material.dart';
import '../models/task_model.dart'; 

class EventList extends StatelessWidget {
  final List<Task> events; 

  const EventList({
    Key? key,
    required this.events,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const Center(
        child: Text(
          'Tidak ada event pada hari ini.',
          style: TextStyle(fontSize: 16, color: Colors.grey), 
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: events.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final task = events[index]; 

        return Card( 
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4.0), 
          child: ListTile(
            leading: const Icon(Icons.task_alt), 
            title: Text(
              task.title, 
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  
                  task.deadline != null
                      ? 'Deadline: ${task.deadline!.day}/${task.deadline!.month}/${task.deadline!.year} ${task.deadline!.hour}:${task.deadline!.minute.toString().padLeft(2, '0')}'
                      : 'Tidak ada deadline',
                ),
                Text('Kategori: ${task.category ?? 'Tidak ada'}'), 
              ],
            ),
            onTap: () {
              print('Task ${task.title} diklik!');
            },
          ),
        );
      },
    );
  }
}