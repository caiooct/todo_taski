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
  int get pageSize => 10;

  @override
  Future<PaginatedResult<List<Todo>>> getUseCase({required int page, required int pageSize, String? query}) async {
    final todos = List.generate(
      pageSize,
      (index) {
        final id = index + (page);
        return Todo(
          id: id,
          title: 'Todo $id',
          content: 'Content $id',
          isCompleted: false,
        );
      },
    );
    final paginatedResult = PaginatedResult<List<Todo>>(
      totalCount: mockTotalCount,
      data: todos,
    );
    return paginatedResult;
  }

  @override
  void updateCheckTodo(Todo todo, bool value, int index) {
    // TODO: implement updateCheckTodo
  }
}

const int mockTotalCount = 50;

void main() {
  late BaseTaskViewModel viewModel;
  late MockTodoRepository mockRepository;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
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

    test('loadMore adds new todos to the list', () async {
      final initialTodos = List.generate(
        10,
        (index) => Todo(
          id: index,
          title: 'Todo $index',
          content: 'Content $index',
          isCompleted: false,
        ),
      );
      viewModel.todoList.addAll(initialTodos);
      viewModel.totalCount = mockTotalCount;
      viewModel.offset = 10;

      final newTodos = List.generate(
        10,
        (index) => Todo(
          id: index + 10,
          title: 'Todo ${index + 10}',
          content: 'Content ${index + 10}',
          isCompleted: false,
        ),
      );

      await viewModel.loadMore();

      expect(viewModel.todoList.length, 20);
      expect(viewModel.todoList, containsAll(newTodos));
      expect(viewModel.offset, 20);
      expect(viewModel.isLoadingMore, isFalse);
    });

    test('loadMore sets isLoadingMore to true while loading', () async {
      final future = viewModel.loadMore();

      expect(viewModel.isLoadingMore, isTrue);

      await future;

      expect(viewModel.isLoadingMore, isFalse);
    });

    test('should update todo and update the todoList', () async {
      final todo = Todo(
        id: 1,
        title: 'Test',
        content: 'Test content',
        isCompleted: false,
      );
      registerFallbackValue(todo);
      when(() => mockRepository.update(any())).thenAnswer((_) async {});

      viewModel.todoList.add(todo);
      viewModel.totalCount = 1;

      await viewModel.updateTodo(todo.copyWith(isCompleted: true), 0);

      expect(viewModel.todoList[0].isCompleted, isTrue);
      verify(()=>mockRepository.update(captureAny())).called(1);
    });

    test('should delete todo and remove from todoList', () async {
      final todo = Todo(
        id: 1,
        title: 'Test',
        content: 'Test content',
        isCompleted: false,
      );
      registerFallbackValue(todo);
      when(() => mockRepository.delete(any())).thenAnswer((_) async {});

      viewModel.todoList.add(todo);
      viewModel.totalCount = 1;
      viewModel.offset = 1;

      await viewModel.deleteTodo(todo);

      expect(viewModel.todoList.isEmpty, isTrue);
      expect(viewModel.totalCount, isZero);
      expect(viewModel.offset, isZero);
      verify(()=>mockRepository.delete(captureAny())).called(1);
    });
  });
}
