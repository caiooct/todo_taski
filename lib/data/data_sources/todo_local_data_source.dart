import 'package:isar/isar.dart';

import '../../domain/models/todo.dart';
import '../../utils/paginated_result.dart';
import 'todo_data_source.dart';

class TodoLocalDataSource implements TodoDataSource {
  final Isar _db;

  const TodoLocalDataSource({required Isar db}) : _db = db;

  IsarCollection<Todo> get _collection => _db.todos;

  @override
  Future<int> create(Todo toDo) async {
    return _db.writeTxn(() async {
      return _collection.put(toDo);
    });
  }

  @override
  Future<void> delete(Todo toDo) async {
    await _db.writeTxn(() async {
      await _collection.delete(toDo.id);
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
  Future<List<Todo>> getDones({required int page, required int pageSize}) async {
    return _collection.filter().isCompletedEqualTo(true).offset(page).limit(pageSize).findAll();
  }

  @override
  Future<List<Todo>> search(String query) {
    return _collection
        .where(distinct: true)
        .filter()
        .contentContains(query, caseSensitive: false)
        .or()
        .titleContains(query, caseSensitive: false)
        .findAll();
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
