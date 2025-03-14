import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/vendor/isar/model/db_todo.dart';

class TodoItem extends StatelessWidget {
  const TodoItem({
    super.key,
    required this.model,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  final DBTodo model;

  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final icon = model.isFinished
        ? Icon(
            Icons.check_box,
            color: context.primaryColor,
          )
        : Icon(
            Icons.check_box_outline_blank,
            color: context.primaryColor,
          );

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: InkWell(
          onTap: onToggle,
          child: icon,
        ),
        title: Text(
          model.title,
          style: TextStyle(
            color: model.isFinished ? context.primaryColor : null,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: onEdit,
              child: Icon(Icons.edit),
            ),
            SizedBox(
              width: 8,
            ),
            GestureDetector(
              onTap: onDelete,
              child: Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
