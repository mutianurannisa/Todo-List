import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/task_model.dart';

class TaskForm extends StatefulWidget {
  final Task? task;
  final Future<void> Function(Task) onSave;

  const TaskForm({super.key, this.task, required this.onSave});

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late DateTime _date;
  late TimeOfDay _time;
  late String? _category; 
  final List<String> _categories = [
    '🌸 Pribadi',
    '🎓 Kuliah',
    '💼 Kerjaan',
    '💡 Ide'
  ];

  @override
  void initState() {
    super.initState();
    _title = widget.task?.title ?? '';
    _description = widget.task?.description ?? '';
    _date = widget.task?.deadline ?? DateTime.now();
    _time = TimeOfDay.fromDateTime(widget.task?.deadline ?? DateTime.now()); 
    _category = widget.task?.category; 
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final selectedDateTime = DateTime(
        _date.year,
        _date.month,
        _date.day,
        _time.hour,
        _time.minute,
      );

      final id = widget.task?.id ?? const Uuid().v4();
      final task = Task(
        id: id,
        title: _title,
        description: _description,
        deadline: selectedDateTime, 
        category: _category,
      );
      widget.onSave(task);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (pickedTime != null) {
      setState(() {
        _time = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add Task' : 'Edit Task',
         style: TextStyle(
          fontFamily: 'baloo', 
          fontSize: 30, 
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter title' : null,
                onSaved: (value) => _title = value ?? '',
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (value) => _description = value ?? '',
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text('Date: ${_date.toLocal().toString().split(' ')[0]}'),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _date,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _date = pickedDate;
                        });
                      }
                    },
                    child: const Text('Select Date'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text('Time: ${_time.format(context)}'),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () => _selectTime(context),
                    child: const Text('Select Time'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                value: _category,
                items: _categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _category = value;
                  });
                },
                onSaved: (value) => _category = value,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}