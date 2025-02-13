import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../config/app_colors.dart';
import '../../../config/assets.dart';
import '../../../config/dependencies.dart';
import '../../../utils/show_snack_bar_helper.dart';
import '../view_models/search_view_model.dart';
import '../widgets/todo_form_bottom_sheet.dart';
import '../widgets/todo_item_widget.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final focusNode = FocusNode();

  final viewModel = injector<SearchViewModel>();

  @override
  void initState() {
    super.initState();
    viewModel.initListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(26, 32, 26, 0),
      child: Column(
        children: [
          ValueListenableBuilder(
            valueListenable: viewModel.textEditingController,
            builder: (_, value, __) {
              return SearchBar(
                focusNode: focusNode,
                controller: viewModel.textEditingController,
                elevation: WidgetStatePropertyAll(0),
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                backgroundColor: WidgetStatePropertyAll(AppColors.paleWhite),
                side: WidgetStatePropertyAll(BorderSide(color: AppColors.blue, width: 2)),
                padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 14)),
                leading: SvgPicture.asset(
                  Assets.searchIcon,
                  height: 16,
                  colorFilter: ColorFilter.mode(AppColors.blue, BlendMode.srcIn),
                ),
                trailing: value.text.isNotEmpty
                    ? [
                        IconButton(
                          icon: SvgPicture.asset(Assets.removeIcon),
                          onPressed: () {
                            viewModel.textEditingController.clear();
                          },
                        )
                      ]
                    : null,
              );
            },
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListenableBuilder(
              listenable: viewModel,
              builder: (context, _) {
                if (viewModel.textEditingController.text.trim().isEmpty) {
                  return SizedBox();
                } else if (viewModel.isLoading || (viewModel.todoList.isEmpty && viewModel.isLoadingMore)) {
                  return Center(child: CircularProgressIndicator());
                } else if (viewModel.todoList.isEmpty) {
                  return Column(
                    children: [
                      Spacer(),
                      SvgPicture.asset(Assets.noData),
                      const SizedBox(height: 24),
                      Text(
                        'No result found.',
                        style: TextTheme.of(context).bodyLarge?.copyWith(color: AppColors.slateBlue),
                      ),
                      Spacer(),
                    ],
                  );
                } else {
                  return ListView.separated(
                    padding: EdgeInsets.only(bottom: 32),
                    controller: viewModel.scrollController,
                    shrinkWrap: true,
                    itemCount: viewModel.canLoadMore ? viewModel.todoList.length + 1 : viewModel.todoList.length,
                    itemBuilder: (_, index) {
                      if (index == viewModel.todoList.length) return Center(child: CircularProgressIndicator());
                      return TodoItemWidget(
                        key: UniqueKey(),
                        todo: viewModel.todoList[index],
                        onCheck: (value) => viewModel.onCheckTodo(viewModel.todoList[index], value, index),
                        onLongPress: () {
                          showModalBottomSheet(
                            barrierColor: Colors.transparent,
                            context: context,
                            builder: (_) => TodoFormBottomSheet(
                              onSave: (updatedTodo) {
                                viewModel.updateTodo(updatedTodo, index);
                              },
                              todo: viewModel.todoList[index],
                            ),
                          );
                        },
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
                          }
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
