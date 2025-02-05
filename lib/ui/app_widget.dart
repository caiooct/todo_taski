import 'package:flutter/material.dart';

import '../config/app_theme.dart';
import 'home/screens/home_screen.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: _onGenerateRoute,
    );
  }

  Route? _onGenerateRoute(RouteSettings settings) {
    final page = switch (settings.name) {
      '/' => const HomeScreen(),
      _ => ErrorWidget(Exception()),
    };
    return MaterialPageRoute(builder: (_) => page, settings: settings);
  }
}
