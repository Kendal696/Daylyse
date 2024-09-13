import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'note_screen.dart';
import 'ai_feedback_screen.dart'; // Importa la nueva pantalla

class DayNotesScreen extends StatefulWidget {
  final DateTime date;
  final List<Map<String, dynamic>> notes;
  final Function(int, String, String)? onEditNote;

  DayNotesScreen({
    required this.date,
    required this.notes,
    this.onEditNote,
  });

  @override
  _DayNotesScreenState createState() => _DayNotesScreenState();
}

class _DayNotesScreenState extends State<DayNotesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notas del ${DateFormat('d MMM yyyy').format(widget.date)}'),
      ),
      body: widget.notes.isEmpty
          ? Center(child: Text('No hay notas para este día'))
          : ListView.builder(
              itemCount: widget.notes.length,
              itemBuilder: (context, index) {
                final note = widget.notes[index];
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
                            onTap: widget.onEditNote != null
                                ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NoteScreen(
                                          onSaveNote: (title, description, date) {
                                            widget.onEditNote!(index, title, description);
                                            setState(() {});
                                          },
                                          note: note,
                                        ),
                                      ),
                                    );
                                  }
                                : null,
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
    );
  }
}
