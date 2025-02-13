import 'package:isar/isar.dart';

import '../../domain/models/todo.dart';
import '../../utils/paginated_result.dart';
import 'todo_data_source.dart';

class TodoLocalDataSource implements TodoDataSource {
  final Isar _db;

  const TodoLocalDataSource({required Isar db}) : _db = db;

  IsarCollection<Todo> get _collection => _db.todos;

  @override
  Future<int> create(Todo todo) async {
    return _db.writeTxn(() async {
      return _collection.put(todo);
    });
  }

  @override
  Future<void> delete(Todo todo) async {
    await _db.writeTxn(() async {
      await _collection.delete(todo.id);
    });
  }

  @override
  Future<PaginatedResult<List<Todo>>> getTodos({required int page, required int pageSize}) async {
    final query = _collection.filter().isCompletedEqualTo(false);
    return PaginatedResult(
      totalCount: await query.count(),
      data: await query.offset(page).limit(pageSize).findAll(),
    );
  }

  @override
  Future<PaginatedResult<List<Todo>>> getDones({required int page, required int pageSize}) async {
    final query = _collection.filter().isCompletedEqualTo(true);
    return PaginatedResult(
      totalCount: await query.count(),
      data: await query.offset(page).limit(pageSize).findAll(),
    );
  }

  @override
  Future<PaginatedResult<List<Todo>>> search(
      {required String query, required int offset, required int pageSize}) async {
    final collection = _collection
        .where()
        .filter()
        .contentContains(query, caseSensitive: false)
        .or()
        .titleContains(query, caseSensitive: false);
    return PaginatedResult(
      totalCount: await collection.count(),
      data: await collection.offset(offset).limit(pageSize).findAll(),
    );
  }

  @override
  Future<void> update(Todo todo) async {
    await _db.writeTxn(() async {
      await _collection.put(todo);
    });
  }

  @override
  Future<void> deleteAllDone() async {
    await _db.writeTxn(() async {
      await _collection.filter().isCompletedEqualTo(true).deleteAll();
    });
  }
}
