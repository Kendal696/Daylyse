import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'note_screen.dart';
import 'settings_screen.dart';
import 'faq_screen.dart';
import 'annual_calendar_screen.dart';
import 'day_notes_screen.dart';
import 'ai_feedback_screen.dart'; // Importa la nueva pantalla

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _isCalendarExpanded = false;
  Map<DateTime, List<Map<String, dynamic>>> _notes = {};
  bool _isSortedByRecent = true;
  String _searchQuery = '';

  void _addNote(String title, String description, DateTime date) {
    setState(() {
      DateTime noteDate = DateTime(date.year, date.month, date.day);
      if (_notes[noteDate] == null) {
        _notes[noteDate] = [];
      }
      _notes[noteDate]!.add({
        'title': title,
        'description': description,
        'date': noteDate,
      });
    });
  }

  void _editNote(DateTime date, int index, String title, String description) {
    setState(() {
      DateTime noteDate = DateTime(date.year, date.month, date.day);
      _notes[noteDate]![index]['title'] = title;
      _notes[noteDate]![index]['description'] = description;
    });
  }

  List<Map<String, dynamic>> _filteredNotes() {
    List<Map<String, dynamic>> allNotes = [];
    _notes.values.forEach((notesList) {
      allNotes.addAll(notesList);
    });

    return allNotes.where((note) {
      return note['title'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          note['description'].toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  // Método para mostrar el diálogo de ordenación
  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ordenar notas'),
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
                    Navigator.pop(context);
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
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> sortedNotes = _filteredNotes();
    sortedNotes.sort((a, b) {
      return _isSortedByRecent
          ? b['date'].compareTo(a['date'])
          : a['date'].compareTo(b['date']);
    });

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Buscar...',
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: Colors.white),
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
            icon: Icon(Icons.sort),
            onPressed: _showSortDialog,
          ),
        ],
      ),
      drawer: Drawer( // Menú hamburguesa
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // ... (DrawerHeader y opciones)
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 64,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Nombre Completo',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configuraciones'),
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
                // Aquí puedes implementar la funcionalidad de cambiar el tema
              },
            ),
            ListTile(
              leading: Icon(Icons.question_answer),
              title: Text('Preguntas Frecuentes'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FaqScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Título y botón para expandir el calendario
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  DateFormat('MMMM yyyy').format(_focusedDay),  // Mes y año
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: Icon(_isCalendarExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down),
                onPressed: () {
                  setState(() {
                    _isCalendarExpanded = !_isCalendarExpanded;
                  });
                },
              ),
            ],
          ),
          if (_isCalendarExpanded)
            TableCalendar(
              firstDay: DateTime.utc(2000, 1, 1),
              lastDay: DateTime.utc(2100, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              eventLoader: (day) {
                DateTime dateWithoutTime = DateTime(day.year, day.month, day.day);
                return _notes[dateWithoutTime] != null && _notes[dateWithoutTime]!.isNotEmpty
                    ? ['note']
                    : [];
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                // Navegar a la pantalla de notas del día
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DayNotesScreen(
                      date: selectedDay,
                      notes: _notes[DateTime(selectedDay.year, selectedDay.month, selectedDay.day)] ?? [],
                      onEditNote: (index, title, description) => _editNote(
                          DateTime(selectedDay.year, selectedDay.month, selectedDay.day),
                          index,
                          title,
                          description),
                    ),
                  ),
                );
              },
              calendarStyle: CalendarStyle(
                markerDecoration: BoxDecoration(
                  color: Colors.blueAccent,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: sortedNotes.length,
              itemBuilder: (context, index) {
                final note = sortedNotes[index];
                final formattedDate = DateFormat('d MMM').format(note['date']);

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Fecha a la izquierda
                        SizedBox(
                          width: 50,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                DateFormat('d').format(note['date']),
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                DateFormat('MMM').format(note['date']),
                                style: TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        // Título y descripción
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              // Navegar a la pantalla de edición de la nota
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NoteScreen(
                                    onSaveNote: (title, description, date) {
                                      _editNote(
                                        DateTime(note['date'].year, note['date'].month, note['date'].day),
                                        _notes[DateTime(note['date'].year, note['date'].month, note['date'].day)]!
                                            .indexOf(note),
                                        title,
                                        description,
                                      );
                                    },
                                    note: note,
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  note['title'],
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  note['description'],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Botón Analizar
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.star, color: Colors.yellow),
                              onPressed: () {
                                // Navegar a la pantalla de feedback de IA
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AIFeedbackScreen(note: note),
                                  ),
                                );
                              },
                            ),
                            Text('Analizar', style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // Botones flotantes
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            heroTag: 'calendar',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AnnualCalendarScreen(notes: _notes)),
              );
            },
            child: Icon(Icons.calendar_today),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          FloatingActionButton(
            heroTag: 'addNote',
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
            child: Icon(Icons.add),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          FloatingActionButton(
            heroTag: 'profile',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
            child: Icon(Icons.person),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
