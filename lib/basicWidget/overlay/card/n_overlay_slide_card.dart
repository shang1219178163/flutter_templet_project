//
//  NOverlaySlideCard.dart
//  flutter_templet_project
//
//  Created by shang on 2026/5/12 16:31.
//  Copyright © 2026/5/12 shang. All rights reserved.
//

import 'package:flutter/widgets.dart';

/// OverlayEntry 动画卡片
class NOverlaySlideCard extends StatefulWidget {
  const NOverlaySlideCard({
    super.key,
    this.alignment = Alignment.centerLeft,
    required this.height,
    required this.top,
    this.left = 0,
    this.right = 0,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.beginOffset = const Offset(1, 0),
    this.curve = Curves.linear,
  });

  final AlignmentGeometry? alignment;

  final double height;

  final double top;

  final double left;

  final double right;

  final Widget Function(Future<void> Function() onDismiss) child;

  /// 动画时间
  final Duration duration;

  final Curve curve;

  /// 初始偏移
  final Offset beginOffset;

  @override
  State<NOverlaySlideCard> createState() => NOverlaySlideCardState();
}

class NOverlaySlideCardState extends State<NOverlaySlideCard> {
  /// 初始在屏幕外
  Offset offset = Offset.zero;

  double opacity = 0;

  bool isDismissing = false;

  @override
  void initState() {
    super.initState();

    offset = widget.beginOffset;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      offset = Offset.zero;
      opacity = 1;
      setState(() {});
    });
  }

  /// dismiss 动画
  Future<void> dismiss() async {
    if (isDismissing || !mounted) {
      return;
    }
    isDismissing = true;
    offset = widget.beginOffset;
    opacity = 0;
    setState(() {});
    await Future.delayed(widget.duration);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: widget.duration,
      top: widget.top,
      left: widget.left,
      right: widget.right,
      child: AnimatedOpacity(
        duration: widget.duration,
        opacity: opacity,
        child: AnimatedSlide(
          duration: widget.duration,
          curve: widget.curve,
          offset: offset,
          child: Container(
            height: widget.height,
            alignment: widget.alignment,
            child: widget.child(dismiss),
          ),
        ),
      ),
    );
  }
}
