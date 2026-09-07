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
    this.controller,
    required this.firstChild,
    required this.secondChild,
    this.alignment = Alignment.topCenter,
    required this.isFirst,
    this.duration = const Duration(milliseconds: 350),
    this.onChanged,
  });

  final NCrossFadeController? controller;

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
  late bool isFirst = widget.isFirst;

  @override
  void dispose() {
    widget.controller?._detach(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    widget.controller?._attach(this);
  }

  @override
  void didUpdateWidget(covariant NCrossFade oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._detach(this);
      widget.controller?._attach(this);
    }
    if (widget.isFirst != oldWidget.isFirst) {
      isFirst = widget.isFirst;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      alignment: widget.alignment,
      duration: widget.duration,
      firstChild: widget.firstChild(onToggle),
      secondChild: widget.secondChild(onToggle),
      crossFadeState: isFirst ? CrossFadeState.showFirst : CrossFadeState.showSecond,
    );
  }

  /// 展开收起
  void onToggle() {
    isFirst = !isFirst;
    setState(() {});
    widget.onChanged?.call(isFirst);
  }
}

class NCrossFadeController {
  _NCrossFadeState? _anchor;

  /// 是否已挂载到 [NCrossFade]
  bool get isAttached => _anchor != null;

  bool? get isFirst {
    return _anchor?.isFirst;
  }

  void _attach(_NCrossFadeState anchor) {
    _anchor = anchor;
  }

  void _detach(_NCrossFadeState anchor) {
    if (_anchor == anchor) {
      _anchor = null;
    }
  }

  void onToggle() {
    assert(_anchor != null);
    _anchor?.onToggle();
  }
}
