import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../config/app_colors.dart';
import '../../../config/assets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();
    screens = [
      SizedBox(),
      SizedBox(),
      SizedBox(),
      SizedBox(),
    ];
  }

  int index = 0;

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
      body: screens[index],
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
        child: BottomNavigationBar(
          onTap: (value) {
            if (value == 1) {
              // TODO: IMPLEMENT
            } else {
              setState(() {
                index = value;
              });
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
