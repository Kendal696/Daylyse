import 'package:daylyse/interfaces/serializable_interface.dart';

class UpdateNoteDto implements Serializable {
  final String? title;
  final String? body;

  UpdateNoteDto({
    this.title,
    this.body,
  });

  factory UpdateNoteDto.fromObject(Map<String, dynamic> json) {
    if (json['title'] == null || json['title'].trim().isEmpty) {
      throw Exception("The title field cannot be empty");
    }

    if (json['body'] == null || json['body'].trim().isEmpty) {
      throw Exception("The body field cannot be empty");
    }

    return UpdateNoteDto(
      title: json['title'],
      body: json['body'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (title != null) {
      json['title'] = title;
    }
    if (body != null) {
      json['body'] = body;
    }

    return json;
  }
}
