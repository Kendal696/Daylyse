import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
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
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _isCalendarExpanded = false;
  Map<DateTime, List<Map<String, dynamic>>> _notes = {};
  bool _isSortedByRecent = true;
  String _searchQuery = '';

  bool _isSelectionMode = false;
  Set<Map<String, dynamic>> _selectedNotes = {};

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
          note['description'].toLowerCase().contains(_searchQuery.toLowerCase());
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
        appBar: CustomAppBar( // Utilizamos el AppBar personalizado
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
        drawer: DrawerMenu(),  // Utilizamos el Drawer separado
        body: Column(
          children: [
            CalendarHeader(  // Utilizamos el header del calendario
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
                      }
                    },
                    onAnalyze: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AIFeedbackScreen(note: note),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingButtons( // Utilizamos los botones flotantes separados
          notes: _notes,
          onAddNote: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NoteScreen(
                  onSaveNote: (title, description, date) => _addNote(title, description, date),
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
