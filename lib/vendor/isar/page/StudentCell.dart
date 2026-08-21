import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/vendor/isar/model/db_student.dart';

class StudentCell extends StatelessWidget {
  const StudentCell({
    super.key,
    required this.model,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  final DBStudent model;

  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final icon = model.isSelected
        ? Icon(
            Icons.check_box,
            color: context.themeData.colorScheme.primary,
          )
        : Icon(
            Icons.check_box_outline_blank,
            color: context.themeData.primaryColor,
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
          model.name,
          style: TextStyle(
            color: model.isSelected ? context.themeData.primaryColor : null,
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<DBStudent>('model', model));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onToggle', onToggle));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onEdit', onEdit));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onDelete', onDelete));
  }
}
