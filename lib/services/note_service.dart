import 'package:daylyse/dtos/note/create_dto.dart';
import 'package:daylyse/dtos/note/update_dto.dart';
import 'package:daylyse/interfaces/repository_interface.dart';
import 'package:daylyse/interfaces/response_interface.dart';
import 'package:daylyse/models/note_model.dart';

class NoteService {
  late RepositoryInterface repository;

  NoteService({required this.repository});

  Future<Response<List<NoteModel>>> getAll() async {
    try {
      List<Map<String, dynamic>> list = await repository.getAll();
      return Response(
          data: list.map((item) => NoteModel.fromJson(item)).toList());
    } catch (e) {
      return Response(errorMessage: e.toString());
    }
  }

  Future<Response<NoteModel>> create(CreateNoteDto note) async {
    try {
      final data = await repository.create(note);
      return Response(data: NoteModel.fromJson(data));
    } catch (e) {
      return Response(errorMessage: e.toString());
    }
  }

  Future<Response<void>> update(String id, UpdateNoteDto note) async {
    try {
      await repository.update(id, note);
      return Response();
    } catch (e) {
      return Response(errorMessage: e.toString());
    }
  }

  Future<Response<void>> delete(String id) async {
    try {
      await repository.delete(id);
      return Response();
    } catch (e) {
      return Response(errorMessage: e.toString());
    }
  }
}
