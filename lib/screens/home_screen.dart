import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'note_screen.dart';
import 'package:intl/intl.dart';  // Para formatear fechas
import 'settings_screen.dart';  // Pantalla para ajustes y tema

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _showCalendar = false;  // Variable para controlar si mostrar el calendario
  List<Map<String, dynamic>> _notes = [];
  bool _isSortedByRecent = true;
  String _searchQuery = '';

  void _addNote(String title, String description, DateTime date) {
    setState(() {
      _notes.add({
        'title': title,
        'description': description,
        'date': date,
        'isFavorite': false,
      });
    });
  }

  void _editNote(int index, String title, String description, DateTime date) {
    setState(() {
      _notes[index]['title'] = title;
      _notes[index]['description'] = description;
      _notes[index]['date'] = date;
    });
  }

  void _toggleFavorite(int index) {
    setState(() {
      _notes[index]['isFavorite'] = !_notes[index]['isFavorite'];
    });
  }

  List<Map<String, dynamic>> _filteredNotes() {
    return _notes.where((note) {
      return note['title'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
             note['description'].toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  // Diálogo para elegir entre "Recientes" o "Antiguos" con Radio Buttons
  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filtrar por'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RadioListTile<bool>(
                title: Text('Recientes'),
                value: true,
                groupValue: _isSortedByRecent,
                onChanged: (bool? value) {
                  setState(() {
                    _isSortedByRecent = value!;
                    Navigator.pop(context);  // Cierra el diálogo
                  });
                },
              ),
              RadioListTile<bool>(
                title: Text('Antiguos'),
                value: false,
                groupValue: _isSortedByRecent,
                onChanged: (bool? value) {
                  setState(() {
                    _isSortedByRecent = value!;
                    Navigator.pop(context);  // Cierra el diálogo
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Verificar si hay una nota en una fecha específica
  bool _hasNoteOnDate(DateTime date) {
    return _notes.any((note) => isSameDay(note['date'], date));
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> sortedNotes = _filteredNotes();
    sortedNotes.sort((a, b) {
      return _isSortedByRecent
          ? b['date'].compareTo(a['date'])  // Más recientes primero
          : a['date'].compareTo(b['date']);  // Más antiguos primero
    });

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Buscar...',
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: Colors.white),  // Lupa dentro del buscador
          ),
          style: TextStyle(color: Colors.white),
          onChanged: (query) {
            setState(() {
              _searchQuery = query;
            });
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              _showSortDialog();  // Mostrar el diálogo de filtro
            },
            tooltip: 'Filtrar por recientes o antiguos',
          ),
        ],
      ),
      drawer: Drawer(  // Menú hamburguesa
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Column(
                children: [
                  Icon(Icons.person, size: 64, color: Colors.white),  // Ícono de perfil
                  SizedBox(height: 8),
                  Text('Perfil', style: TextStyle(color: Colors.white, fontSize: 24)),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Ajustes'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.brightness_6),
              title: Text('Tema'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),  // Dirige a la pantalla para cambiar el tema
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Botón para mostrar/ocultar el calendario
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _showCalendar = !_showCalendar;  // Alterna la visibilidad del calendario
                  });
                },
                icon: Icon(Icons.calendar_today),
                label: Text(_showCalendar ? 'Ocultar Calendario' : 'Ver Calendario'),
              ),
              // Botón para agregar nota
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NoteScreen(
                        onSaveNote: (title, description, date) => _addNote(title, description, date),
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.add),
                label: Text('Añadir Nota'),
              ),
            ],
          ),
          if (_showCalendar)  // Mostrar el calendario si _showCalendar es true
            TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(
                  color: Colors.green,  // Color del "tick" o check si hay una nota en esa fecha
                  shape: BoxShape.circle,
                ),
                markersMaxCount: 1,
              ),
              eventLoader: (day) {
                if (_hasNoteOnDate(day)) {
                  return ['tick'];  // Muestra un marcador si hay una nota en ese día
                }
                return [];
              },
            ),
          // Lista de notas
          Expanded(
            child: ListView.builder(
              itemCount: sortedNotes.length,
              itemBuilder: (context, index) {
                final note = sortedNotes[index];
                final formattedDate = DateFormat('d MMM').format(note['date']);  // Formato de la fecha

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('d').format(note['date']),  // Día
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          DateFormat('MMM').format(note['date']),  // Mes
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                    title: Text(note['title']),
                    subtitle: Text(note['description']),
                    trailing: IconButton(
                      icon: Icon(
                        note['isFavorite'] ? Icons.star : Icons.star_border,
                        color: note['isFavorite'] ? Colors.yellow : null,
                      ),
                      onPressed: () {
                        _toggleFavorite(index);
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NoteScreen(
                            onSaveNote: (title, description, date) => _editNote(index, title, description, date),
                            note: note,  // Pasamos la nota para editar
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
