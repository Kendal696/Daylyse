import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarHeader extends StatelessWidget {
  final DateTime focusedDay;
  final bool isCalendarExpanded;
  final VoidCallback onExpandToggle;

  const CalendarHeader({
    required this.focusedDay,
    required this.isCalendarExpanded,
    required this.onExpandToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            DateFormat('MMMM yyyy').format(focusedDay),  // Mes y año
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(
          icon: Icon(isCalendarExpanded
              ? Icons.keyboard_arrow_up
              : Icons.keyboard_arrow_down),
          onPressed: onExpandToggle,
        ),
      ],
    );
  }
}
