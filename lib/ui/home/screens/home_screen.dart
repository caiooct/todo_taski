import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../config/app_colors.dart';
import '../../../config/assets.dart';
import '../../../config/dependencies.dart';
import '../tabs/todo_tab.dart';
import '../view_models/home_view_model.dart';
import '../view_models/todo_view_model.dart';
import '../widgets/todo_form_bottom_sheet.dart';

class HomeScreen extends StatefulWidget {
  final HomeViewModel viewModel;

  const HomeScreen({required this.viewModel, super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final List<Widget> screens;

  HomeViewModel get viewModel => widget.viewModel;

  TodoViewModel todoViewModel = injector<TodoViewModel>();

  @override
  void initState() {
    super.initState();
    screens = [
      TodoTab(todoViewModel),
      SizedBox(), // A bottom sheet is shown instead of a screen
      SizedBox(),
      SizedBox(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 26,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            Image.asset(Assets.logo, height: 28),
            Spacer(),
            Text('John', style: TextTheme.of(context).titleLarge?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(width: 10),
            ClipOval(child: Image.asset(Assets.profile, height: 42)),
          ],
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: viewModel,
        builder: (_, index, __) => screens[index],
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              offset: Offset(0, -20),
              color: Colors.white,
              blurRadius: 40,
              spreadRadius: 1,
            ),
          ],
        ),
        child: ValueListenableBuilder(
          valueListenable: viewModel,
          builder: (_, index, __) {
            return BottomNavigationBar(
              onTap: (value) {
                if (value == 1) {
                  showModalBottomSheet(
                    barrierColor: Colors.transparent,
                    context: context,
                    builder: (_) => TodoFormBottomSheet(
                      onSave: (newTodo) {
                        viewModel.goToTab(0);
                        todoViewModel.createTodo(newTodo, canScroll: true);
                      },
                    ),
                  );
                } else {
                  viewModel.goToTab(value);
                }
              },
              selectedLabelStyle: TextTheme.of(context).labelLarge?.copyWith(fontWeight: FontWeight.w600),
              unselectedLabelStyle: TextTheme.of(context).labelLarge?.copyWith(fontWeight: FontWeight.w600),
              currentIndex: index,
              selectedItemColor: AppColors.blue,
              unselectedItemColor: AppColors.mutedAzure,
              backgroundColor: Colors.white,
              type: BottomNavigationBarType.fixed,
              items: [
                _TabItem(iconPath: Assets.todoIcon, label: 'Todo'),
                _TabItem(iconPath: Assets.createIcon, label: 'Create'),
                _TabItem(iconPath: Assets.searchIcon, label: 'Search'),
                _TabItem(iconPath: Assets.doneIcon, label: 'Done'),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TabItem extends BottomNavigationBarItem {
  final String iconPath;

  _TabItem({
    required this.iconPath,
    required super.label,
  }) : super(
          icon: SvgPicture.asset(iconPath),
          activeIcon: SvgPicture.asset(
            iconPath,
            colorFilter: ColorFilter.mode(AppColors.blue, BlendMode.srcIn),
          ),
        );
}
