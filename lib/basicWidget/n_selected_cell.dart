//
//  NSelectedCell.dart
//  flutter_templet_project
//
//  Created by shang on 2024/4/3 16:13.
//  Copyright © 2024/4/3 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';

class NSelectedCell extends StatefulWidget {
  NSelectedCell({
    super.key,
    this.selectedIcon = const Icon(
      Icons.check_circle,
      size: 16,
      color: Colors.blue,
    ),
    this.unselectedIcon = const Icon(
      Icons.radio_button_unchecked,
      size: 16,
    ),
    required this.isSelected,
    required this.onToggle,
    required this.child,
  });

  bool isSelected;

  final VoidCallback onToggle;
  final Widget selectedIcon;
  final Widget unselectedIcon;
  final Widget child;

  @override
  State<NSelectedCell> createState() => _NSelectedCellState();
}

class _NSelectedCellState extends State<NSelectedCell> {
  @override
  Widget build(BuildContext context) {
    // final icon = widget.isSelected ? Icons.check_circle : Icons.check;
    final icon =
        widget.isSelected ? widget.selectedIcon : widget.unselectedIcon;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: [
          InkWell(
            onTap: widget.onToggle,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 15,
                right: 10,
                top: 15,
                bottom: 15,
              ),
              child: icon,
            ),
          ),
          Expanded(
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
