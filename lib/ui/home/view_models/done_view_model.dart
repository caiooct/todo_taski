import 'package:flutter/material.dart';

import '../../../domain/models/todo.dart';
import '../../../utils/paginated_result.dart';
import 'base_task_view_model.dart';

class DoneViewModel extends BaseTaskViewModel {
  DoneViewModel({required super.repository});

  @override
  Future<PaginatedResult<List<Todo>>> getUseCase({required int page, required int pageSize, String? query}) =>
      repository.getDones(page: offset, pageSize: pageSize);

  Future<void> load() async {
    reset();
    notifyListeners();
    await getDones();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (canLoadMore) {
        checkLoadMoreWhenNoScroll();
      }
    });
  }

  Future<void> getDones() async {
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
      todoList.insert(index, todo);
      totalCount++;
      offset++;
    } else {
      todoList.removeAt(index);
      totalCount--;
      offset--;
    }
    await repository.update(todo.copyWith(isCompleted: value));
    notifyListeners();
  }

  void deleteAllDone() async {
    await repository.deleteAllDone();
    reset();
    notifyListeners();
  }
}
