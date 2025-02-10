import 'package:flutter/material.dart';

import '../config/app_theme.dart';
import '../config/dependencies.dart';
import 'home/screens/home_screen.dart';
import 'home/view_models/home_view_model.dart';

final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldKey,
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: _onGenerateRoute,
    );
  }

  Route? _onGenerateRoute(RouteSettings settings) {
    final page = switch (settings.name) {
      '/' => HomeScreen(viewModel: injector<HomeViewModel>()),
      _ => ErrorWidget(Exception()),
    };
    return MaterialPageRoute(builder: (_) => page, settings: settings);
  }
}
