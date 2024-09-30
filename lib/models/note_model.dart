class NoteModel  {
  late String id;
  late String title;
  late String body;
  late DateTime createdAt;
  late DateTime updatedAt;
  late String idUser;

  NoteModel({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.updatedAt,
    required this.idUser,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json["id"]!,
      title: json["title"]!,
      body: json["body"]!,
      createdAt: DateTime.parse(json["created_at"]!),
      updatedAt: DateTime.parse(json["updated_at"]!),
      idUser: json["id_user"]!,
    );
  }
}
