//
//  TweenTransitionDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2024/6/17 12:17.
//  Copyright © 2024/6/17 shang. All rights reserved.
//

import 'package:flutter/material.dart';

/// 装饰器动画
class CurvedAnimationWidget<T> extends StatefulWidget {
  const CurvedAnimationWidget({
    super.key,
    required this.curve,
    this.child,
    required this.builder,
  });

  final Curve curve;
  final Widget? child;

  final Widget Function(BuildContext context, Widget? child, CurvedAnimation animation) builder;

  @override
  State<CurvedAnimationWidget<T>> createState() => _CurvedAnimationWidgetState<T>();
}

class _CurvedAnimationWidgetState<T> extends State<CurvedAnimationWidget<T>> with SingleTickerProviderStateMixin {
  late final controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2000),
  );

  late final animation = CurvedAnimation(
    parent: controller,
    curve: widget.curve,
  );

  @override
  void initState() {
    super.initState();

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      }
      if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  void startAnim() {
    controller.reset();
    controller.forward();
  }

  @override
  void didUpdateWidget(covariant CurvedAnimationWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: startAnim,
      child: AnimatedBuilder(
        animation: controller,
        child: widget.child,
        builder: (c, child) {
          return widget.builder(c, child, animation);
        },
      ),
    );
  }
}
