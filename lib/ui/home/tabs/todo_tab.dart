// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../config/app_colors.dart';
import '../../../config/assets.dart';
import '../view_models/todo_view_model.dart';
import '../widgets/todo_form_bottom_sheet.dart';
import '../widgets/todo_item_widget.dart';

class TodoTab extends StatefulWidget {
  const TodoTab(this.todoViewModel, {super.key});

  final TodoViewModel todoViewModel;

  @override
  State<TodoTab> createState() => _TodoTabState();
}

class _TodoTabState extends State<TodoTab> {
  TodoViewModel get viewModel => widget.todoViewModel;

  @override
  void initState() {
    super.initState();
    viewModel
      ..initListeners()
      ..load();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          if (viewModel.isLoading || (viewModel.todoList.isEmpty && viewModel.isLoadingMore)) {
            return Center(child: CircularProgressIndicator());
          }
          return Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(26, 32, 26, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text.rich(
                  TextSpan(
                    text: 'Welcome, ',
                    children: [
                      TextSpan(text: 'John', style: TextStyle(color: AppColors.blue)),
                      TextSpan(text: '.'),
                    ],
                  ),
                  style: TextTheme.of(context)
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold, color: AppColors.slatePurple),
                ),
                const SizedBox(height: 10),
                Text(
                  Intl.plural(
                    viewModel.totalCount,
                    zero: 'Create tasks to achieve more',
                    one: "You've got 1 task to do",
                    other: "You've got ${viewModel.totalCount} tasks to do",
                  ),
                  style: TextTheme.of(context).bodyLarge?.copyWith(color: AppColors.slateBlue),
                ),
                const SizedBox(height: 32),
                if (viewModel.todoList.isEmpty)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(Assets.noData),
                          const SizedBox(height: 24),
                          Text(
                            'You have no task listed.',
                            style: TextTheme.of(context).bodyLarge?.copyWith(color: AppColors.slateBlue),
                          ),
                          const SizedBox(height: 28),
                          OutlinedButton.icon(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              showModalBottomSheet(
                                barrierColor: Colors.transparent,
                                context: context,
                                builder: (_) => TodoFormBottomSheet(
                                  onSave: (newTodo) {
                                    viewModel.createTodo(newTodo);
                                  },
                                ),
                              );
                            },
                            label: Text('Create task'),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.only(bottom: 32),
                      controller: viewModel.scrollController,
                      shrinkWrap: true,
                      itemCount: viewModel.canLoadMore ? viewModel.todoList.length + 1 : viewModel.todoList.length,
                      itemBuilder: (context, index) {
                        if (index == viewModel.todoList.length) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        final todo = viewModel.todoList[index];
                        return TodoItemWidget(
                          key: UniqueKey(),
                          todo: todo,
                          onCheck: (value) => viewModel.onCheckTodo(todo, value, index),
                          onLongPress: () {
                            showModalBottomSheet(
                              barrierColor: Colors.transparent,
                              context: context,
                              builder: (_) => TodoFormBottomSheet(
                                todo: viewModel.todoList[index],
                                onSave: (updatedTodo) {
                                  viewModel.updateTodo(updatedTodo, index);
                                },
                              ),
                            );
                          },
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(height: 8),
                    ),
                  ),
              ],
            ),
          );
        });
  }

  @override
  void dispose() {
    viewModel.clearListeners();
    super.dispose();
  }
}
