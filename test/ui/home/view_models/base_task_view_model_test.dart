import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_taski/data/repositories/todo_repository.dart';
import 'package:todo_taski/domain/models/todo.dart';
import 'package:todo_taski/ui/home/view_models/base_task_view_model.dart';
import 'package:todo_taski/utils/paginated_result.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

class MockBaseTaskViewModel extends BaseTaskViewModel {
  MockBaseTaskViewModel({required super.repository});

  @override
  Future<PaginatedResult<List<Todo>>> getUseCase({required int page, required int pageSize, String? query}) async {
    final todos = List.generate(
        10,
        (index) => Todo(
              id: index,
              title: 'Todo $index',
              content: 'Content $index',
              isCompleted: false,
            ));
    final paginatedResult = PaginatedResult<List<Todo>>(
      totalCount: 20,
      data: todos,
    );
    return paginatedResult;
  }

  @override
  void updateCheckTodo(Todo todo, bool value, int index) {
    // TODO: implement updateCheckTodo
  }
}

void main() {
  late BaseTaskViewModel viewModel;
  late MockTodoRepository mockRepository;

  setUp(() {
    mockRepository = MockTodoRepository();
    viewModel = MockBaseTaskViewModel(repository: mockRepository);
  });

  group('BaseTaskViewModel Tests', () {
    test('Initial values are correct', () {
      expect(viewModel.offset, isZero);
      expect(viewModel.isLoading, isFalse);
      expect(viewModel.isLoadingMore, isFalse);
      expect(viewModel.todoList, isEmpty);
      expect(viewModel.totalCount, isZero);
      viewModel.loadMore();
    });

    test('should reset values', () {
      viewModel.offset = 1;
      viewModel.isLoading = true;
      viewModel.isLoadingMore = true;
      viewModel.todoList.add(Todo(
        id: 1,
        title: 'Test',
        content: 'Test content',
        isCompleted: false,
      ));
      viewModel.totalCount = 1;

      viewModel.reset();

      expect(viewModel.offset, isZero);
      expect(viewModel.isLoading, isFalse);
      expect(viewModel.isLoadingMore, isFalse);
      expect(viewModel.todoList, isEmpty);
      expect(viewModel.totalCount, isZero);
    });
  });
}
