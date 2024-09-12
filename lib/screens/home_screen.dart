import 'package:flutter/material.dart';
import 'annual_calendar_screen.dart';  // Importa la pantalla del calendario anual
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'note_screen.dart';
import 'settings_screen.dart';
import 'faq_screen.dart';  // Pantalla de Preguntas Frecuentes

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _isCalendarExpanded = false;  // Controla si el calendario está expandido o colapsado
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
        // Dejar el botón de menú hamburguesa predeterminado para abrir el Drawer
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
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

          // Mostrar el calendario expandido si la flecha es presionada
          if (_isCalendarExpanded)
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
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: sortedNotes.length,
              itemBuilder: (context, index) {
                final note = sortedNotes[index];
                final formattedDate = DateFormat('d MMM').format(note['date']);

                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('d').format(note['date']),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          DateFormat('MMM').format(note['date']),
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                    title: Text(note['title']),
                    subtitle: Text(note['description']),
                    trailing: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            note['isFavorite']
                                ? Icons.star
                                : Icons.star_border,
                            color: note['isFavorite']
                                ? Colors.yellow
                                : null,
                          ),
                          onPressed: () {
                            _toggleFavorite(index);
                          },
                        ),
                        Text('Analizar',
                            style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NoteScreen(
                            onSaveNote: (title, description, date) =>
                                _editNote(index, title, description, date),
                            note: note,
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
      // Botones flotantes
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            heroTag: 'calendar',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AnnualCalendarScreen()),
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
                    onSaveNote: (title, description, date) =>
                        _addNote(title, description, date),
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
