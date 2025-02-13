import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../config/app_colors.dart';
import '../../../config/assets.dart';
import '../../../config/dependencies.dart';
import '../../../utils/show_snack_bar_helper.dart';
import '../view_models/done_view_model.dart';
import '../widgets/todo_form_bottom_sheet.dart';
import '../widgets/todo_item_widget.dart';

class DoneTab extends StatefulWidget {
  const DoneTab({super.key});

  @override
  State<DoneTab> createState() => _DoneTabState();
}

class _DoneTabState extends State<DoneTab> {
  final viewModel = injector<DoneViewModel>();

  @override
  void initState() {
    super.initState();
    viewModel
      ..initListeners()
      ..load();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(26, 32, 26, 0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Completed Tasks',
                style: TextTheme.of(context)
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold, color: AppColors.slatePurple),
              ),
              Spacer(),
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Delete all tasks'),
                        content: const Text('Are you sure you want to delete all completed tasks?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              viewModel.deleteAllDone();
                              Navigator.pop(context);
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text(
                  'Delete all',
                  style: TextTheme.of(context).titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.fireRed,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListenableBuilder(
                listenable: viewModel,
                builder: (context, _) {
                  if (viewModel.isLoading || (viewModel.todoList.isEmpty && viewModel.isLoadingMore)) {
                    return Center(child: CircularProgressIndicator());
                  } else if (viewModel.todoList.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(Assets.noData),
                          const SizedBox(height: 24),
                          Text(
                            'You have no task listed.',
                            style: TextTheme.of(context).bodyLarge?.copyWith(color: AppColors.slateBlue),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
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

                      return TodoItemWidget(
                        key: UniqueKey(),
                        todo: viewModel.todoList[index],
                        onDelete: () {
                          if (viewModel.isLoadingMore) {
                            ShowSnackBarHelper.showErrorSnackBar('Wait for the loading to finish');
                            return;
                          }
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Delete Task'),
                                content: const Text('Are you sure you want to delete this task?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      viewModel.deleteTodo(viewModel.todoList[index]);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        onCheck: (value) => viewModel.onCheckTodo(viewModel.todoList[index], value, index),
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
                  );
                }),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    viewModel.clearListeners();
    super.dispose();
  }
}
