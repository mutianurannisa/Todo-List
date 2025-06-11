import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../widgets/calender_widget.dart'; 
import '../widgets/event_list_widget.dart';
import '../providers/task_provider.dart';
import '../models/task_model.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  late List<Task> _selectedEvents;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
    _selectedEvents = Provider.of<TaskProvider>(context, listen: false)
        .getIncompleteTasksForDate(_selectedDay);
  }

  void _onDaySelected(DateTime selected, DateTime focused) {
    if (!isSameDay(_selectedDay, selected)) {
      setState(() {
        _selectedDay = selected;
        _focusedDay = focused;
        _selectedEvents = Provider.of<TaskProvider>(context, listen: false)
            .getIncompleteTasksForDate(selected);
      });
    }
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    return Provider.of<TaskProvider>(context, listen: false)
        .getIncompleteTasksForDate(day);
  }

  Widget _buildCustomMarker(BuildContext context, DateTime day, List<dynamic> events) {
    if (events.isEmpty) {
      return const SizedBox.shrink();
    }

    final Color dotColor = Colors.pink.shade300;

    return Positioned(
      bottom: 5, 
      child: Center( 
        child: Row(
          mainAxisSize: MainAxisSize.min, 
          children: List.generate(
            events.length > 3 ? 3 : events.length, 
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 1.0),
              width: 7.0,
              height: 7.0,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        _selectedEvents = taskProvider.getIncompleteTasksForDate(_selectedDay);

        return Scaffold(
          appBar: AppBar(
            title: const Text ('Calendar',
             style: TextStyle(
            fontFamily: 'baloo', 
            fontSize: 30, 
              ),
            ),
          ),
          body: Column(
            children: [
              CalendarWidget(
                selectedDay: _selectedDay,
                focusedDay: _focusedDay,
                onDaySelected: _onDaySelected,
                eventLoader: _getEventsForDay,
                markerBuilder: _buildCustomMarker, 
              ),
              const Divider(height: 1),
              Expanded(
                child: EventList(events: _selectedEvents),
              ),
            ],
          ),
        );
      },
    );
  }
}