import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  DateTime _selectedDate = DateTime.now();  // Fecha seleccionada

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!['title'];
      _descriptionController.text = widget.note!['description'];
      _selectedDate = widget.note!['date'];
    }
  }

  // Función para abrir el DatePicker y seleccionar una fecha
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,  // Fecha inicial
      firstDate: DateTime(2000),   // Fecha mínima
      lastDate: DateTime(2100),    // Fecha máxima
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;  // Actualizar la fecha seleccionada
      });
    }
  }

  // Cambiar la fecha al día anterior
  void _previousDay() {
    setState(() {
      _selectedDate = _selectedDate.subtract(Duration(days: 1));
    });
  }

  // Cambiar la fecha al día siguiente
  void _nextDay() {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: 1));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () => _selectDate(context),  // Abre el selector de fecha al tocar la fecha
          child: Row(
            mainAxisSize: MainAxisSize.min,  // Minimiza el espacio ocupado por el título
            children: [
              Icon(Icons.calendar_today, size: 20),
              SizedBox(width: 8),
              Text(
                DateFormat('d MMM yyyy').format(_selectedDate),  // Muestra la fecha seleccionada
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back),  // Ícono para cambiar al día anterior
            onPressed: _previousDay,
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward),  // Ícono para cambiar al día siguiente
            onPressed: _nextDay,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Spacer(),
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
