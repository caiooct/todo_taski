import '../../domain/models/todo.dart';
import '../../utils/paginated_result.dart';

abstract interface class TodoRepository {
  Future<int> create(Todo toDo);

  Future<PaginatedResult<List<Todo>>> getTodos({required int page, required int pageSize});

  Future<PaginatedResult<List<Todo>>> getDones({required int page, required int pageSize});

  Future<void> update(Todo toDo);

  Future<PaginatedResult<List<Todo>>> search({required String query, required int offset, required int pageSize});

  Future<void> delete(Todo toDo);

  Future<void> deleteAllDone();
}
