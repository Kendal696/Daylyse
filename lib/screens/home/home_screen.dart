import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../note_screen.dart';
import 'day_notes_screen.dart';
import '../ai_feedback_screen.dart';
import 'components/note_card.dart';
import 'components/custom_app_bar.dart';
import 'components/calendar_header.dart';
import 'components/drawer_menu.dart';
import 'components/floating_buttons.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _isCalendarExpanded = false;
  bool _isSortedByRecent = true;
  String _searchQuery = '';

  String? _userId;
  Map<DateTime, List<Map<String, dynamic>>> _notes = {};
  bool _isSelectionMode = false;
  Set<Map<String, dynamic>> _selectedNotes = {};

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() async {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.uid;
      });
      _loadUserNotes();
    }
  }

  void _loadUserNotes() async {
    if (_userId != null) {
      QuerySnapshot snapshot = await _firestore
          .collection('notes')
          .where('idUser', isEqualTo: _userId)
          .get();

      setState(() {
        _notes.clear();
        for (var doc in snapshot.docs) {
          DateTime noteDate = (doc['createdAt'] as Timestamp).toDate();
          noteDate = DateTime(noteDate.year, noteDate.month, noteDate.day);

          if (_notes[noteDate] == null) {
            _notes[noteDate] = [];
          }

          final data = doc.data() as Map<String, dynamic>?;

          _notes[noteDate]!.add({
            'title':
                data != null && data.containsKey('title') ? data['title'] : '',
            'description':
                data != null && data.containsKey('body') ? data['body'] : '',
            'date': noteDate,
          });
        }
      });
    }
  }

  void _addNote(String title, String description, DateTime date) async {
    if (_userId != null) {
      await _firestore.collection('notes').add({
        'title': title,
        'body': description,
        'createdAt': Timestamp.fromDate(date),
        'idUser': _userId,
      });
      _loadUserNotes();
    }
  }

  // Método para editar una nota en la lista local
  void _editNote(DateTime date, int index, String title, String description) {
    setState(() {
      DateTime noteDate = DateTime(date.year, date.month, date.day);
      _notes[noteDate]![index]['title'] = title;
      _notes[noteDate]![index]['description'] = description;
    });
  }

  // Método para eliminar las notas seleccionadas
  void _deleteSelectedNotes() {
    setState(() {
      _selectedNotes.forEach((note) {
        DateTime noteDate = note['date'];
        _notes[noteDate]?.remove(note);
        if (_notes[noteDate]?.isEmpty ?? false) {
          _notes.remove(noteDate);
        }
      });
      _selectedNotes.clear();
      _isSelectionMode = false;
    });
  }

  List<Map<String, dynamic>> _filteredNotes() {
    List<Map<String, dynamic>> allNotes = [];
    _notes.values.forEach((notesList) {
      allNotes.addAll(notesList);
    });

    return allNotes.where((note) {
      return note['title'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          note['description']
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
    }).toList();
  }

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

    return WillPopScope(
      onWillPop: () async {
        if (_isSelectionMode) {
          setState(() {
            _isSelectionMode = false;
            _selectedNotes.clear();
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          isSelectionMode: _isSelectionMode,
          selectedCount: _selectedNotes.length,
          onSearchChanged: (query) {
            setState(() {
              _searchQuery = query;
            });
          },
          onSortPressed: _showSortDialog,
          onCloseSelection: () {
            setState(() {
              _isSelectionMode = false;
              _selectedNotes.clear();
            });
          },
          onDeleteSelected: _deleteSelectedNotes,
        ),
        drawer: DrawerMenu(),
        body: Column(
          children: [
            CalendarHeader(
              focusedDay: _focusedDay,
              isCalendarExpanded: _isCalendarExpanded,
              onExpandToggle: () {
                setState(() {
                  _isCalendarExpanded = !_isCalendarExpanded;
                });
              },
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
                  DateTime dateWithoutTime =
                      DateTime(day.year, day.month, day.day);
                  return _notes[dateWithoutTime] != null &&
                          _notes[dateWithoutTime]!.isNotEmpty
                      ? ['note']
                      : [];
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DayNotesScreen(
                        date: selectedDay,
                        notes: _notes[DateTime(selectedDay.year,
                                selectedDay.month, selectedDay.day)] ??
                            [],
                        onEditNote: (index, title, description) => _editNote(
                            DateTime(selectedDay.year, selectedDay.month,
                                selectedDay.day),
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
                  final isSelected = _selectedNotes.contains(note);

                  return NoteCard(
                    note: note,
                    isSelected: isSelected,
                    onLongPress: () {
                      setState(() {
                        _isSelectionMode = true;
                        _selectedNotes.add(note);
                      });
                    },
                    onTap: () {
                      if (_isSelectionMode) {
                        setState(() {
                          if (isSelected) {
                            _selectedNotes.remove(note);
                            if (_selectedNotes.isEmpty) {
                              _isSelectionMode = false;
                            }
                          } else {
                            _selectedNotes.add(note);
                          }
                        });
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NoteScreen(
                              onSaveNote: (title, description, date) {
                                _editNote(
                                  DateTime(note['date'].year,
                                      note['date'].month, note['date'].day),
                                  _notes[DateTime(
                                          note['date'].year,
                                          note['date'].month,
                                          note['date'].day)]!
                                      .indexOf(note),
                                  title,
                                  description,
                                );
                              },
                              note: note,
                            ),
                          ),
                        );
                      }
                    },
                    onAnalyze: () {
                      if (note['description'] != null &&
                          note['description'].isNotEmpty) {
                        print(
                            "Descripción de la nota: ${note['description']}"); // Imprime el contenido de la descripción
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AIFeedbackScreen(note: note),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'La nota está vacía y no se puede analizar.')),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingButtons(
          notes: _notes,
          onAddNote: () {
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
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
