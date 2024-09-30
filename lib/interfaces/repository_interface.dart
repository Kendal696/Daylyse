import 'package:daylyse/interfaces/serializable_interface.dart';

abstract class RepositoryInterface<T extends Serializable> {
  Future<List<Map<String, dynamic>>> getAll({Map<String, dynamic>? filter});
  Future<Map<String, dynamic>> create(T entity);
  Future<Map<String, dynamic>?> getById(String id);
  Future<void> update(String id, T entity);
  Future<void> delete(String id);
}