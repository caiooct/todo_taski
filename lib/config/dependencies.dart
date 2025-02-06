import 'package:auto_injector/auto_injector.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../domain/models/todo.dart';
import '../ui/home/view_models/home_view_model.dart';

final injector = AutoInjector();

Future<void> injectDependencies() async {
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [TodoSchema],
    directory: dir.path,
  );
  injector.addInstance(isar);
  injector.add(HomeViewModel.new);
  injector.commit();
}
