import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatelessWidget {
  final DateTime selectedDay;
  final DateTime focusedDay;
  final void Function(DateTime, DateTime) onDaySelected;
  final List<dynamic> Function(DateTime)? eventLoader;

  final Widget? Function(BuildContext context, DateTime day, List<dynamic> events)? markerBuilder;

  const CalendarWidget({
    Key? key,
    required this.selectedDay,
    required this.focusedDay,
    required this.onDaySelected,
    this.eventLoader,
    this.markerBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) { 
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: focusedDay,
      selectedDayPredicate: (day) => isSameDay(day, selectedDay),
      eventLoader: eventLoader,
      onDaySelected: onDaySelected,
      calendarStyle: const CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Color(0xFF3A2951),
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.purple,
          shape: BoxShape.circle,
        ),
      ),
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      calendarBuilders: CalendarBuilders(
        markerBuilder: markerBuilder, 
      ),
    );
  }
}