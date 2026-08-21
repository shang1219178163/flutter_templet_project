//
//  NSlidableDeleteCell.dart
//  flutter_templet_project
//
//  Created by shang on 2024/6/5 18:31.
//  Copyright © 2024/6/5 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class NSlidableDeleteCell extends StatelessWidget {
  const NSlidableDeleteCell({
    super.key,
    required this.child,
    this.startActionPane,
    this.endActionPane,
    this.onDelete,
  });

  final Widget child;
  final VoidCallback? onDelete;

  final ActionPane? startActionPane;
  final ActionPane? endActionPane;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: const ValueKey(0),
      startActionPane: startActionPane,
      endActionPane: endActionPane ??
          ActionPane(
            motion: ScrollMotion(),
            children: [
              // SlidableAction(
              //   onPressed: (ctx) => onPin,
              //   backgroundColor: Colors.blue,
              //   foregroundColor: Colors.white,
              //   icon: Icons.push_pin,
              //   label: '置顶',
              // ),
              if (onDelete != null)
                SlidableAction(
                  onPressed: (ctx) => onDelete,
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: '删除',
                ),
            ],
          ),
      child: child,
    );
  }
}
