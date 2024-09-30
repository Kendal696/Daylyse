import 'package:daylyse/interfaces/repository_interface.dart';
import 'package:daylyse/interfaces/serializable_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreRepository<T extends Serializable>
    implements RepositoryInterface<T> {
  late CollectionReference _collection;
  final String collection;

  FirestoreRepository({required this.collection}) {
    _collection = FirebaseFirestore.instance.collection(collection);
  }

  @override
  Future<Map<String, dynamic>> create(T entity) async {
    final result = await _collection.add(entity.toJson()).then((response)=>response.get());
    return {"id": result.id, ...result.data() as Map<String,dynamic>};
  }

  @override
  Future<void> delete(String id) async {
    await _collection.doc(id).delete();
  }

  @override
  Future<List<Map<String, dynamic>>> getAll(
      {Map<String, dynamic>? filter}) async {
    return _collection.get() as List<Map<String, dynamic>>;
  }

  @override
  Future<Map<String, dynamic>> getById(String id) async {
    return await _collection.doc(id).get() as Map<String, dynamic>;
  }

  @override
  Future<void> update(String id, T entity) async {
    await _collection.doc(id).update(entity.toJson());
  }
}
