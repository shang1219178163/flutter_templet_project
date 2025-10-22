import 'package:flutter/material.dart';

class NPreferredSizeWidget extends StatelessWidget implements PreferredSizeWidget {
  const NPreferredSizeWidget({
    super.key,
    required this.childSize,
    required this.child,
  });

  final Size childSize;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }

  @override
  Size get preferredSize => childSize;
}
