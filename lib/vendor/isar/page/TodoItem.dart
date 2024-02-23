

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/vendor/isar/model/db_todo.dart';


class TodoItem extends StatelessWidget {
  const TodoItem({
    super.key,
    required this.model,
    required this.onToggleFinished,
    required this.onDelete
  });

  final DBTodo model;

  final VoidCallback onToggleFinished;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: GestureDetector(
          onTap: () => onToggleFinished(),
          child: Icon(
            model.isFinished ? Icons.check_box : Icons.check_box_outline_blank,
            color: Colors.green,
          ),
        ),
        title: Text(
          model.title,
          style: TextStyle(
              decoration: model.isFinished ? TextDecoration.lineThrough : null),
        ),
        trailing: GestureDetector(
          onTap: () => onDelete(),
          child: Icon(Icons.delete),
        ),
      ),
    );
  }
}