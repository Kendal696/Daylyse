import 'dart:async';
import 'package:flutter/material.dart';
import '../services/openai_service.dart';

class AIFeedbackScreen extends StatefulWidget {
  final Map<String, dynamic> note;

  AIFeedbackScreen({required this.note});

  @override
  _AIFeedbackScreenState createState() => _AIFeedbackScreenState();
}

class _AIFeedbackScreenState extends State<AIFeedbackScreen> {
  final OpenAIService openAIService = OpenAIService(
      "");
  String feedback = "Generando retroalimentación...";
  String displayedFeedback = "";
  int _feedbackIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _getFeedback();
  }

  Future<void> _getFeedback() async {
    try {
      if (widget.note['description'] == null ||
          widget.note['description'].isEmpty) {
        throw Exception("El contenido de la nota está vacío o es nulo.");
      }
      final result =
          await openAIService.getFeedback(widget.note['description']);
      setState(() {
        feedback = result;
      });
      _startTypingEffect();
    } catch (e) {
      setState(() {
        feedback = "Error al obtener retroalimentación: $e";
        displayedFeedback = feedback; // Mostrar el error directamente
      });
    }
  }

  void _startTypingEffect() {
    _feedbackIndex = 0;
    displayedFeedback = "";
    _timer = Timer.periodic(Duration(milliseconds: 15), (timer) {
      if (_feedbackIndex < feedback.length) {
        setState(() {
          displayedFeedback += feedback[_feedbackIndex];
          _feedbackIndex++;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Retroalimentación de IA"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Contenido de la Nota:",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                widget.note['description'] ?? "Sin contenido",
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Retroalimentación de IA:",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 93, 141, 224),
              ),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 110, 156, 236),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                displayedFeedback,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
