import 'package:flutter/material.dart';

import '../../../data/repositories/todo_repository.dart';
import '../../../domain/models/todo.dart';
import '../../../utils/paginated_result.dart';
import '../../../utils/show_snack_bar_helper.dart';

abstract class BaseTaskViewModel extends ChangeNotifier {
  final TodoRepository repository;

  BaseTaskViewModel({required this.repository});

  bool get canLoadMore => todoList.length < totalCount;
  int totalCount = 0;
  bool isLoading = false;
  bool isLoadingMore = false;
  int offset = 0;

  final todoList = <Todo>[];
  final scrollController = ScrollController();

  int get pageSize => 50;

  Future<PaginatedResult<List<Todo>>> getUseCase({required int page, required int pageSize, String? query});

  void initListeners() {
    scrollController.addListener(() {
      if (canLoadMore &&
          !isLoading &&
          !isLoadingMore &&
          scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
        loadMore();
      }
    });
  }

  void checkLoadMoreWhenNoScroll() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (canLoadMore &&
          scrollController.hasClients &&
          scrollController.position.maxScrollExtent <= scrollController.position.viewportDimension) {
        await loadMore();
        checkLoadMoreWhenNoScroll();
      }
    });
  }

  Future<void> loadMore() async {
    isLoadingMore = true;
    notifyListeners();

    final result = await getUseCase(page: offset, pageSize: pageSize);
    if (result.isNotEmpty) {
      todoList.addAll(result.data);
      totalCount = result.totalCount;
      offset = todoList.length;
    }

    isLoadingMore = false;
    notifyListeners();
  }

  void reset() {
    offset = 0;
    isLoading = false;
    isLoadingMore = false;
    todoList.clear();
    totalCount = 0;
  }

  Future<void> updateTodo(Todo todo, int index) async {
    await repository.update(todo);
    todoList[index] = todo;
    notifyListeners();
    ShowSnackBarHelper.showSuccessSnackBar('Task updated successfully');
  }

  Future<void> onCheckTodo(Todo todo, bool value, int index) async {
    if (isLoadingMore) {
      ShowSnackBarHelper.showErrorSnackBar('Wait for the loading to finish');
      return;
    }
    updateCheckTodo(todo, value, index);
    ShowSnackBarHelper.showSuccessSnackBar(
      'Task updated successfully',
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () => updateCheckTodo(todo, !value, index),
      ),
    );
  }

  void updateCheckTodo(Todo todo, bool value, int index);

  void deleteTodo(Todo todo) async {
    await repository.delete(todo);
    todoList.removeWhere((element) => element.id == todo.id);
    offset--;
    totalCount--;
    notifyListeners();
    ShowSnackBarHelper.showSuccessSnackBar('Task deleted successfully');
  }
}
