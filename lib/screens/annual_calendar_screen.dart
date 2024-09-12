import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class AnnualCalendarScreen extends StatelessWidget {
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
          
          // Aquí ajustamos el focusedDay al firstDay del mes actual
          DateTime focusedDay = firstDay;

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
                focusedDay: focusedDay,  // El día enfocado será el primer día del mes
                calendarFormat: CalendarFormat.month,  // Mostrar solo el mes actual
                headerVisible: false,  // Ocultar encabezado de cada calendario
                calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.lightBlueAccent,
                    shape: BoxShape.circle,
                  ),
                ),
                availableGestures: AvailableGestures.none,  // Desactivar gestos para evitar cambiar el mes
              ),
              SizedBox(height: 16.0),
            ],
          );
        },
      ),
    );
  }
}
