import 'package:flutter/material.dart';

class AIFeedbackScreen extends StatelessWidget {
  final Map<String, dynamic> note;

  AIFeedbackScreen({required this.note});

  @override
  Widget build(BuildContext context) {
    // Aquí puedes implementar la lógica de la IA para generar feedback
    String feedback = 'Este es un feedback generado por la IA para la nota titulada "${note['title']}".';

    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback de IA'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          feedback,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
