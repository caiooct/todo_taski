import 'package:auto_injector/auto_injector.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../data/data_sources/todo_data_source.dart';
import '../data/data_sources/todo_local_data_source.dart';
import '../data/repositories/todo_repository.dart';
import '../data/repositories/todo_repository_impl.dart';
import '../domain/models/todo.dart';
import '../ui/home/view_models/done_view_model.dart';
import '../ui/home/view_models/home_view_model.dart';
import '../ui/home/view_models/search_view_model.dart';
import '../ui/home/view_models/todo_view_model.dart';

final injector = AutoInjector();

Future<void> injectDependencies() async {
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [TodoSchema],
    directory: dir.path,
  );
  injector.addInstance(isar);
  injector.add<TodoDataSource>(TodoLocalDataSource.new);
  injector.add<TodoRepository>(TodoRepositoryImpl.new);
  injector.add(HomeViewModel.new);
  injector.add(SearchViewModel.new);
  injector.add(TodoViewModel.new);
  injector.add(DoneViewModel.new);
  injector.commit();
}
