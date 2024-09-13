import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'day_notes_screen.dart';

class AnnualCalendarScreen extends StatelessWidget {
  final Map<DateTime, List<Map<String, dynamic>>> notes;

  AnnualCalendarScreen({required this.notes});

  @override
  Widget build(BuildContext context) {
    final List<String> months = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];

    final int currentYear = DateTime.now().year;

    // Función para obtener el primer día del mes
    DateTime _getFirstDayOfMonth(int year, int month) {
      return DateTime(year, month, 1);
    }

    // Función para obtener el último día del mes
    DateTime _getLastDayOfMonth(int year, int month) {
      return DateTime(year, month + 1, 0);  // El día 0 del mes siguiente es el último día del mes actual
    }

    // Función para obtener las fechas que tienen notas
    List<DateTime> _getDaysWithNotesInMonth(int month) {
      return notes.keys.where((date) => date.month == month).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Calendario Anual $currentYear'),
      ),
      body: ListView.builder(
        itemCount: months.length,
        itemBuilder: (context, index) {
          // Obtener el primer y último día del mes actual
          DateTime firstDay = _getFirstDayOfMonth(currentYear, index + 1);
          DateTime lastDay = _getLastDayOfMonth(currentYear, index + 1);

          // Fechas con notas en este mes
          List<DateTime> daysWithNotes = _getDaysWithNotesInMonth(index + 1);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${months[index]} $currentYear',  // Nombre del mes y año
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              TableCalendar(
                firstDay: firstDay,
                lastDay: lastDay,
                focusedDay: firstDay,
                calendarFormat: CalendarFormat.month,
                headerVisible: false,
                availableGestures: AvailableGestures.none,
                eventLoader: (day) {
                  DateTime dateWithoutTime = DateTime(day.year, day.month, day.day);
                  return notes[dateWithoutTime] != null && notes[dateWithoutTime]!.isNotEmpty
                      ? ['note']
                      : [];
                },
                onDaySelected: (selectedDay, focusedDay) {
                  // Navegar a la pantalla de notas del día
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DayNotesScreen(
                        date: selectedDay,
                        notes: notes[DateTime(selectedDay.year, selectedDay.month, selectedDay.day)] ?? [],
                      ),
                    ),
                  );
                },
                calendarStyle: CalendarStyle(
                  markerDecoration: BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.lightBlueAccent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
            ],
          );
        },
      ),
    );
  }
}
