import 'package:daylyse/interfaces/serializable_interface.dart';

class CreateNoteDto implements Serializable {
  final String title;
  final String body;
  final DateTime createdAt;
  final String idUser;

  CreateNoteDto({
    required this.title,
    required this.body,
    required this.createdAt,
    required this.idUser,
  });

  factory CreateNoteDto.fromObject(Map<String, dynamic> json) {
    if (json['title'] == null || json['title'].isEmpty) {
      throw Exception("The 'title' field is required");
    }
    if (json['body'] == null || json['body'].isEmpty) {
      throw Exception("The 'body' field is required");
    }
    if (json['createdAt'] == null) {
      throw Exception("The 'createdAt' field is required");
    }
    if (json['idUser'] == null || json['idUser'].isEmpty) {
      throw Exception("The 'idUser' field is required");
    }

    return CreateNoteDto(
      title: json['title'],
      body: json['body'],
      createdAt: json["createdAt"],
      idUser: json['idUser'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'created_at': createdAt.toIso8601String(),
      'updated_at': createdAt.toIso8601String(),
      'id_user': idUser,
    };
  }
}
