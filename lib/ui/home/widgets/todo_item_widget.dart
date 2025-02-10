import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../config/app_colors.dart';
import '../../../domain/models/todo.dart';

class TodoItemWidget extends StatefulWidget {
  final Todo todo;
  final Function(bool) onCheck;
  final VoidCallback? onDelete;
  final VoidCallback? onLongPress;

  const TodoItemWidget({
    required this.todo,
    required this.onCheck,
    super.key,
    this.onDelete,
    this.onLongPress,
  });

  @override
  State<TodoItemWidget> createState() => _TodoItemWidgetState();
}

class _TodoItemWidgetState extends State<TodoItemWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: widget.onLongPress,
      child: ExpansionTile(
        onExpansionChanged: (value) {
          setState(() => _isExpanded = value);
        },
        childrenPadding: EdgeInsets.fromLTRB(64, 0, 16, 16),
        tilePadding: EdgeInsets.symmetric(horizontal: 16),
        showTrailingIcon: !_isExpanded && (widget.todo.content?.isNotEmpty ?? false) && !widget.todo.isCompleted,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              activeColor: AppColors.mutedAzure,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
              side: BorderSide(color: AppColors.mutedAzure, width: 2),
              value: widget.todo.isCompleted,
              onChanged: (value) => widget.onCheck.call(value ?? false),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  '${widget.todo.id} - ${widget.todo.title}',
                  maxLines: _isExpanded ? null : 1,
                  overflow: _isExpanded ? null : TextOverflow.ellipsis,
                  style: GoogleFonts.urbanist(
                    textStyle: Theme.of(context).textTheme.titleMedium,
                    fontWeight: FontWeight.w600,
                    color: widget.todo.isCompleted ? AppColors.slateBlue.withValues(alpha: 0.7) : AppColors.slatePurple,
                  ),
                ),
              ),
            ),
            if (widget.todo.isCompleted) ...[
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.delete, color: AppColors.fireRed),
                onPressed: widget.onDelete,
              ),
            ],
          ],
        ),
        iconColor: Colors.transparent,
        collapsedBackgroundColor: AppColors.paleWhite,
        backgroundColor: AppColors.paleWhite,
        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
        trailing: Icon(Icons.more_horiz, color: AppColors.mutedAzure),
        enabled: widget.todo.content?.isNotEmpty ?? false,
        expandedAlignment: Alignment.topLeft,
        children: [
          Text(
            widget.todo.content ?? '',
            textAlign: TextAlign.start,
            style: TextTheme.of(context).bodyMedium?.copyWith(fontWeight: FontWeight.w500, color: AppColors.slateBlue),
          ),
        ],
      ),
    );
  }
}
