import 'package:auto_injector/auto_injector.dart';

import '../ui/home/view_models/home_view_model.dart';

final injector = AutoInjector();

Future<void> injectDependencies() async {
  injector.add(HomeViewModel.new);
  injector.commit();
}
