import 'package:flutter/material.dart';

import 'config/dependencies.dart';
import 'ui/app_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await injectDependencies();
  runApp(const AppWidget());
}
