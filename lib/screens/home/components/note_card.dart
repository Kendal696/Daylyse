import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoteCard extends StatelessWidget {
  final Map<String, dynamic> note;
  final bool isSelected;
  final Function onLongPress;
  final Function onTap;
  final Function onAnalyze;

  NoteCard({
    required this.note,
    required this.isSelected,
    required this.onLongPress,
    required this.onTap,
    required this.onAnalyze,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('d MMM').format(note['date']);

    return GestureDetector(
      onLongPress: () => onLongPress(),
      onTap: () => onTap(),
      child: Container(
        color: isSelected ? Colors.grey[300] : Colors.transparent,
        child: Card(
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
                // Botón Analizar
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.star, color: Colors.yellow),
                      onPressed: () => onAnalyze(),
                    ),
                    Text('Analizar', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
