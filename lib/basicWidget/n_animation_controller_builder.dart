//
//  TweenTransitionDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2024/6/17 12:17.
//  Copyright © 2024/6/17 shang. All rights reserved.
//

import 'package:flutter/material.dart';

/// NAnimationControllerBuilder 带动画控制器
class NAnimationControllerBuilder<T> extends StatefulWidget {
  const NAnimationControllerBuilder({
    super.key,
    required this.duration,
    this.reverseDuration,
    this.debugLabel,
    this.lowerBound = 0.0,
    this.upperBound = 1.0,
    this.animationBehavior = AnimationBehavior.normal,
    this.child,
    required this.builder,
  });

  /// The length of time this animation should last.
  final Duration? duration;

  /// The length of time this animation should last when going in [reverse].
  final Duration? reverseDuration;

  /// The value at which this animation is deemed to be dismissed.
  final double lowerBound;

  /// The value at which this animation is deemed to be completed.
  final double upperBound;

  /// A label that is used in the [toString] output. Intended to aid with
  /// identifying animation controller instances in debug output.
  final String? debugLabel;

  /// The behavior of the controller when [AccessibilityFeatures.disableAnimations]
  /// is true.
  final AnimationBehavior animationBehavior;

  /// The child widget to pass to the [builder].
  final Widget? child;

  final Widget Function(BuildContext context, Widget? child, AnimationController animController) builder;

  @override
  State<NAnimationControllerBuilder<T>> createState() => _NAnimationControllerBuilderState<T>();
}

class _NAnimationControllerBuilderState<T> extends State<NAnimationControllerBuilder<T>>
    with SingleTickerProviderStateMixin {
  late var controller = AnimationController(
    vsync: this,
    duration: widget.duration,
    reverseDuration: widget.reverseDuration,
    debugLabel: widget.debugLabel,
    lowerBound: widget.lowerBound,
    upperBound: widget.upperBound,
    animationBehavior: widget.animationBehavior,
  );

  @override
  void dispose() {
    controller.removeStatusListener(statusLtr);
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    initData();
  }

  initData() {
    controller.removeStatusListener(statusLtr);
    controller.addStatusListener(statusLtr);
    controller.forward();
  }

  statusLtr(status) {
    if (status == AnimationStatus.completed) {
      controller.reverse();
    }
    if (status == AnimationStatus.dismissed) {
      controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant NAnimationControllerBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration ||
        oldWidget.reverseDuration != widget.reverseDuration ||
        oldWidget.debugLabel != widget.debugLabel ||
        oldWidget.lowerBound != widget.lowerBound ||
        oldWidget.upperBound != widget.upperBound ||
        oldWidget.animationBehavior != widget.animationBehavior ||
        oldWidget.child != widget.child) {
      controller = AnimationController(
        vsync: this,
        duration: widget.duration,
        reverseDuration: widget.reverseDuration,
        debugLabel: widget.debugLabel,
        lowerBound: widget.lowerBound,
        upperBound: widget.upperBound,
        animationBehavior: widget.animationBehavior,
      );
      initData();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      child: widget.child,
      builder: (c, child) {
        return widget.builder(c, child, controller);
      },
    );
  }
}
