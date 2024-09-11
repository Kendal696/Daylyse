import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  // Para manejar fechas

class NoteScreen extends StatefulWidget {
  final Function(String, String, DateTime) onSaveNote;
  final Map<String, dynamic>? note;  // Nota opcional (para edición)

  NoteScreen({required this.onSaveNote, this.note});

  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!['title'];
      _descriptionController.text = widget.note!['description'];
      _selectedDate = widget.note!['date'];
    }
  }

  // Cambiar la fecha al día siguiente
  void _nextDay() {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: 1));
    });
  }

  // Cambiar la fecha al día anterior
  void _previousDay() {
    setState(() {
      _selectedDate = _selectedDate.subtract(Duration(days: 1));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Añadir Nueva Nota' : 'Editar Nota'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Título',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Descripción',
              ),
              maxLines: 5,
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: _previousDay,  // Cambia al día anterior
                ),
                Text(
                  DateFormat('d MMM yyyy').format(_selectedDate),  // Fecha actual
                  style: TextStyle(fontSize: 16),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: _nextDay,  // Cambia al día siguiente
                ),
              ],
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                final title = _titleController.text;
                final description = _descriptionController.text;
                if (title.isNotEmpty && description.isNotEmpty) {
                  widget.onSaveNote(title, description, _selectedDate);  // Guarda la nota con la fecha seleccionada
                  Navigator.pop(context);  // Regresa a la pantalla anterior
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Por favor, rellena ambos campos')),
                  );
                }
              },
              child: Text(widget.note == null ? 'Guardar Nota' : 'Actualizar Nota'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
