import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIService {
  final String apiKey;

  OpenAIService(this.apiKey);

  Future<String> getFeedback(String noteContent) async {
    if (noteContent.isEmpty) {
      return "El contenido de la nota está vacío.";
    }

    final url = Uri.parse("https://api.openai.com/v1/chat/completions");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {
            "role": "user",
            "content":
                "Dame una retroalimentación sobre el siguiente contenido: $noteContent"
          }
        ],
        "max_tokens": 400,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'].trim();
    } else {
      throw Exception("Error al obtener retroalimentación: ${response.body}");
    }
  }
}
