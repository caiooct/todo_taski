import 'package:flutter/material.dart';

import '../../../domain/models/todo.dart';
import '../../../utils/paginated_result.dart';
import '../../../utils/show_snack_bar_helper.dart';
import 'base_task_view_model.dart';

class TodoViewModel extends BaseTaskViewModel {
  TodoViewModel({required super.repository});

  @override
  Future<PaginatedResult<List<Todo>>> getUseCase({required int page, required int pageSize, String? query}) =>
      repository.getTodos(page: offset, pageSize: pageSize);

  Future<void> load() async {
    reset();
    notifyListeners();
    await getTodos();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (canLoadMore) {
        checkLoadMoreWhenNoScroll();
      }
    });
  }

  Future<void> getTodos() async {
    isLoading = true;
    notifyListeners();

    final result = await getUseCase(page: offset, pageSize: pageSize);
    if (result.isNotEmpty) {
      todoList.addAll(result.data);
      totalCount = result.totalCount;
      offset = todoList.length;
    }

    isLoading = false;
    notifyListeners();
  }

  @override
  void updateCheckTodo(Todo todo, bool value, int index) async {
    if (value) {
      todoList.removeAt(index);
      totalCount--;
      offset--;
    } else {
      todoList.insert(index, todo);
      offset++;
      totalCount++;
    }
    await repository.update(todo.copyWith(isCompleted: value));
    notifyListeners();
  }

  void createTodo(Todo todo, {bool canScroll = false}) async {
    final id = await repository.create(todo);
    if (!canLoadMore) {
      todoList.add(todo.copyWith(id: id));
      totalCount++;
      offset++;
      notifyListeners();
      if (canScroll) {
        WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());
      }
    }
    ShowSnackBarHelper.showSuccessSnackBar('Task created successfully');
  }

  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
