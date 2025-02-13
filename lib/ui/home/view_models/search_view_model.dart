import 'dart:async';

import 'package:flutter/material.dart';

import '../../../domain/models/todo.dart';
import '../../../utils/paginated_result.dart';
import 'base_task_view_model.dart';

class SearchViewModel extends BaseTaskViewModel {
  SearchViewModel({required super.repository});

  @override
  Future<PaginatedResult<List<Todo>>> getUseCase({required int page, required int pageSize, String? query}) =>
      repository.search(query: query ?? '', offset: offset, pageSize: pageSize);

  Timer? _debounce;

  final textEditingController = TextEditingController();

  @override
  void initListeners() {
    textEditingController.addListener(_onSearch);
    super.initListeners();
  }

  void _onSearch() {
    searchTodos(textEditingController.text);
  }

  @override
  void updateCheckTodo(Todo todo, bool value, int index) async {
    todoList[index] = todo.copyWith(isCompleted: value);
    await repository.update(todo.copyWith(isCompleted: value));
    notifyListeners();
  }

  Future<void> searchTodos(String query) async {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    isLoading = true;
    notifyListeners();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      reset();
      if (query.trim().isNotEmpty) {
        final result = await repository.search(query: textEditingController.text, offset: offset, pageSize: pageSize);
        if (result.isNotEmpty) {
          todoList.addAll(result.data);
          totalCount = result.totalCount;
          offset = todoList.length;
          checkLoadMoreWhenNoScroll();
        }
      }
      isLoading = false;
      notifyListeners();
    });
  }

  @override
  void clearListeners() {
    super.clearListeners();
    textEditingController.removeListener(_onSearch);
  }
}
