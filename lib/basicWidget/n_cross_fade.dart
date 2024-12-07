//
//  NCrossFade.dart
//  flutter_templet_project
//
//  Created by shang on 2024/12/7 10:10.
//  Copyright © 2024/12/7 shang. All rights reserved.
//

import 'package:flutter/material.dart';

/// AnimatedCrossFade 封装
class NCrossFade extends StatefulWidget {
  const NCrossFade({
    super.key,
    required this.firstChild,
    required this.secondChild,
    this.alignment = Alignment.topCenter,
    required this.isFirst,
    this.duration = const Duration(milliseconds: 350),
    this.onChanged,
  });

  final Widget Function(VoidCallback onToggle) firstChild;

  final Widget Function(VoidCallback onToggle) secondChild;

  /// 对齐方式
  final AlignmentGeometry alignment;

  /// 改换动画时长
  final Duration duration;

  /// 是否默认显示 firstChild
  final bool isFirst;

  /// 改变回调
  final ValueChanged<bool>? onChanged;

  @override
  State<NCrossFade> createState() => _NCrossFadeState();
}

class _NCrossFadeState extends State<NCrossFade> {
  late var isFirst = widget.isFirst;

  @override
  void didUpdateWidget(covariant NCrossFade oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.firstChild != widget.firstChild ||
        oldWidget.secondChild != widget.secondChild ||
        oldWidget.alignment != widget.alignment ||
        oldWidget.duration != widget.duration ||
        oldWidget.duration != widget.duration ||
        oldWidget.isFirst != widget.isFirst) {
      isFirst = widget.isFirst;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: widget.duration,
      firstChild: widget.firstChild(onToggle),
      secondChild: widget.secondChild(onToggle),
      crossFadeState: isFirst ? CrossFadeState.showFirst : CrossFadeState.showSecond,
    );
  }

  /// 展开收起
  onToggle() {
    isFirst = !isFirst;
    widget.onChanged?.call(isFirst);
    setState(() {});
  }
}
