import 'package:flutter/material.dart';

import '../../../config/app_colors.dart';
import '../../../domain/models/todo.dart';

class TodoFormBottomSheet extends StatelessWidget {
  final Function(Todo todo) onSave;
  final Todo? todo;

  TodoFormBottomSheet({
    required this.onSave,
    super.key,
    this.todo,
  });

  late final _titleTextController = TextEditingController()..text = todo?.title ?? '';
  late final _contentTextController = TextEditingController()..text = todo?.content ?? '';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.paleWhite50,
            offset: const Offset(0, -6),
            blurRadius: 24,
          ),
        ],
      ),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 34),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Icon(
                  todo?.isCompleted == true ? Icons.check_box : Icons.check_box_outline_blank,
                  color: AppColors.mutedAzure,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    validator: (value) => value?.isEmpty == true ? 'Title cannot be empty' : null,
                    controller: _titleTextController,
                    decoration: InputDecoration.collapsed(hintText: "What's on your mind"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Icon(Icons.edit, color: AppColors.mutedAzure),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _contentTextController,
                    decoration: InputDecoration.collapsed(hintText: 'Add a note'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.pop(context);
                  onSave(
                    todo != null
                        ? todo!.copyWith(
                            title: _titleTextController.text.trim(),
                            content: _contentTextController.text.trim(),
                          )
                        : Todo(
                            title: _titleTextController.text.trim(),
                            isCompleted: todo?.isCompleted ?? false,
                            content: _contentTextController.text.trim(),
                          ),
                  );
                }
              },
              child: Text(
                todo != null ? 'Update' : 'Create',
                style: TextTheme.of(context).bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.blue,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
