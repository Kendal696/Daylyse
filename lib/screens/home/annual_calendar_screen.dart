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
    final int currentMonthIndex = DateTime.now().month - 1; // Índice basado en 0

    // Crear una lista de índices de meses comenzando desde el mes actual
    List<int> monthIndices = List.generate(12, (index) => (currentMonthIndex + index) % 12);

    // Función para obtener el primer día del mes
    DateTime _getFirstDayOfMonth(int year, int month) {
      return DateTime(year, month, 1);
    }

    // Función para obtener el último día del mes
    DateTime _getLastDayOfMonth(int year, int month) {
      return DateTime(year, month + 1, 0);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Calendario Anual $currentYear'),
      ),
      body: ListView.builder(
        itemCount: months.length,
        itemBuilder: (context, index) {
          // Obtener el índice del mes actual ajustado
          int monthIndex = monthIndices[index];

          // Obtener el primer y último día del mes actual
          DateTime firstDay = _getFirstDayOfMonth(currentYear, monthIndex + 1);
          DateTime lastDay = _getLastDayOfMonth(currentYear, monthIndex + 1);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado del mes con fondo de color
              Container(
                width: double.infinity,
                color: Colors.blueGrey[50],
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${months[monthIndex]} $currentYear',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              TableCalendar(
                firstDay: firstDay,
                lastDay: lastDay,
                focusedDay: DateTime.now().month == monthIndex + 1 ? DateTime.now() : firstDay,
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
                  selectedDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  outsideDaysVisible: false,
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: Colors.black),
                  weekendStyle: TextStyle(color: Colors.red),
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
