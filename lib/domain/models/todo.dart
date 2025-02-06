import 'package:isar/isar.dart';

part 'todo.g.dart';

@collection
class Todo {
  final Id id;
  final String? content;
  final String title;
  final bool isCompleted;

  const Todo({required this.title, required this.isCompleted, this.id = Isar.autoIncrement, this.content});

  @override
  String toString() {
    return 'Todo{id: $id, content: $content, title: $title, isCompleted: $isCompleted}';
  }

  Todo copyWith({
    Id? id,
    String? content,
    String? title,
    bool? isCompleted,
  }) {
    return Todo(
      id: id ?? this.id,
      content: content ?? this.content,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
