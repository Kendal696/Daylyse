import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoteScreen extends StatefulWidget {
  final Function(String, String, DateTime) onSaveNote;
  final Map<String, dynamic>? note; // Nota opcional (para edición)

  NoteScreen({required this.onSaveNote, this.note});

  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now(); // Fecha seleccionada

  // Variables para el formato de texto
  bool _isBold = false;
  bool _isH1 = false;
  bool _isH2 = false;
  bool _isH3 = false;
  Color _textColor = Colors.black;

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
      initialDate: _selectedDate, // Fecha inicial
      firstDate: DateTime(2000), // Fecha mínima
      lastDate: DateTime(2100), // Fecha máxima
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate; // Actualizar la fecha seleccionada
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

  TextStyle _getTextStyle() {
    double fontSize = 16;
    if (_isH1) {
      fontSize = 24;
    } else if (_isH2) {
      fontSize = 20;
    } else if (_isH3) {
      fontSize = 18;
    }

    return TextStyle(
      fontSize: fontSize,
      fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
      color: _textColor,
    );
  }

  void _selectTextColor() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Selecciona un color'),
          content: SingleChildScrollView(
            child: Wrap(
              spacing: 10,
              children: [
                _buildColorOption(Colors.black),
                _buildColorOption(Colors.red),
                _buildColorOption(Colors.green),
                _buildColorOption(Colors.blue),
                _buildColorOption(Colors.orange),
                _buildColorOption(Colors.purple),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildColorOption(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _textColor = color;
        });
        Navigator.of(context).pop();
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey),
        ),
      ),
    );
  }

  // Función para restablecer el estilo después de un salto de línea
  void _onDescriptionChanged(String text) {
    if (text.endsWith('\n')) {
      setState(() {
        // Restablecer estilos al presionar Enter
        _isH1 = false;
        _isH2 = false;
        _isH3 = false;
        // Opcionalmente restablecer negrita y color
        // _isBold = false;
        // _textColor = Colors.black;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () => _selectDate(context), // Abre el selector de fecha al tocar la fecha
          child: Row(
            mainAxisSize: MainAxisSize.min, // Minimiza el espacio ocupado por el título
            children: [
              Icon(Icons.calendar_today, size: 20),
              SizedBox(width: 8),
              Text(
                DateFormat('d MMM yyyy').format(_selectedDate), // Muestra la fecha seleccionada
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back), // Ícono para cambiar al día anterior
            onPressed: _previousDay,
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward), // Ícono para cambiar al día siguiente
            onPressed: _nextDay,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo de título sin barra gris
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Título',
                border: InputBorder.none, // Elimina la barra gris
              ),
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16.0),
            // Campo de descripción sin barra gris y con estilos
            Expanded(
              child: TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Escribe más aquí', // Cambia la etiqueta
                  border: InputBorder.none, // Elimina la barra gris
                ),
                maxLines: null,
                expands: true,
                style: _getTextStyle(),
                onChanged: _onDescriptionChanged,
              ),
            ),
            // Barra de herramientas debajo del campo de texto
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.format_bold,
                      color: _isBold ? Colors.blue : Colors.black),
                  onPressed: () {
                    setState(() {
                      _isBold = !_isBold;
                    });
                  },
                ),
                IconButton(
                  icon: Text('H1',
                      style: TextStyle(
                          color: _isH1 ? Colors.blue : Colors.black,
                          fontWeight: FontWeight.bold)),
                  onPressed: () {
                    setState(() {
                      _isH1 = true;
                      _isH2 = false;
                      _isH3 = false;
                    });
                  },
                ),
                IconButton(
                  icon: Text('H2',
                      style: TextStyle(
                          color: _isH2 ? Colors.blue : Colors.black,
                          fontWeight: FontWeight.bold)),
                  onPressed: () {
                    setState(() {
                      _isH1 = false;
                      _isH2 = true;
                      _isH3 = false;
                    });
                  },
                ),
                IconButton(
                  icon: Text('H3',
                      style: TextStyle(
                          color: _isH3 ? Colors.blue : Colors.black,
                          fontWeight: FontWeight.bold)),
                  onPressed: () {
                    setState(() {
                      _isH1 = false;
                      _isH2 = false;
                      _isH3 = true;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.color_lens, color: _textColor),
                  onPressed: _selectTextColor,
                ),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final title = _titleController.text;
                final description = _descriptionController.text;
                if (title.isNotEmpty && description.isNotEmpty) {
                  widget.onSaveNote(
                      title, description, _selectedDate); // Guarda la nota
                  Navigator.pop(context); // Regresa a la pantalla anterior
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Por favor, rellena ambos campos')),
                  );
                }
              },
              child:
                  Text(widget.note == null ? 'Guardar Nota' : 'Actualizar Nota'),
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
