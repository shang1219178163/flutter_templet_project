//
//  TweenTransitionDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2024/6/17 12:17.
//  Copyright © 2024/6/17 shang. All rights reserved.
//

import 'package:flutter/material.dart';

/// Tween动画 (TweenAnimationBuilder 没有动画控制器,无法二次触发动画)
class TweenTransitionWidget<T> extends StatefulWidget {
  const TweenTransitionWidget({
    super.key,
    required this.tween,
    this.child,
    required this.builder,
  });

  final Tween<T> tween;

  final Widget? child;

  final Widget Function(BuildContext context, Widget? child, AnimationController animController) builder;

  @override
  State<TweenTransitionWidget<T>> createState() => _TweenTransitionWidgetState<T>();
}

class _TweenTransitionWidgetState<T> extends State<TweenTransitionWidget<T>> with SingleTickerProviderStateMixin {
  late final controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2000),
  );

  late Animation<T> animation = widget.tween.animate(controller);

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
  void didUpdateWidget(covariant TweenTransitionWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tween != widget.tween || oldWidget.child != widget.child) {
      animation = widget.tween.animate(controller);
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
          return widget.builder(c, child, controller);
        },
      ),
    );
  }
}
