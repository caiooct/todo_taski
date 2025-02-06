import '../../domain/models/todo.dart';
import '../../utils/paginated_result.dart';
import '../data_sources/todo_data_source.dart';
import 'todo_repository.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoDataSource _dataSource;

  const TodoRepositoryImpl({
    required TodoDataSource dataSource,
  }) : _dataSource = dataSource;

  @override
  Future<int> create(Todo todo) => _dataSource.create(todo);

  @override
  Future<void> delete(Todo todo) => _dataSource.delete(todo);

  @override
  Future<PaginatedResult<List<Todo>>> getTodos({required int page, required int pageSize}) =>
      _dataSource.getTodos(page: page, pageSize: pageSize);

  @override
  Future<List<Todo>> getDones({required int page, required int pageSize}) =>
      _dataSource.getDones(page: page, pageSize: pageSize);

  @override
  Future<List<Todo>> search(String query) => _dataSource.search(query);

  @override
  Future<void> update(Todo todo) => _dataSource.update(todo);

  @override
  Future<void> deleteAllDone() => _dataSource.deleteAllDone();
}
