//
//  NTweenTransition.dart
//  flutter_templet_project
//
//  Created by shang on 2024/9/30 09:33.
//  Copyright © 2024/9/30 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class NTweenTransition<T> extends StatefulWidget {
  const NTweenTransition({
    super.key,
    required this.tween,
    this.duration = const Duration(milliseconds: 300),
    required this.builder,
  });

  final Tween<T> tween;
  final Duration duration;
  final Widget Function(BuildContext context, Animation<T>) builder;

  @override
  State<NTweenTransition<T>> createState() => _NTweenTransitionState<T>();
}

class _NTweenTransitionState<T> extends State<NTweenTransition<T>>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  )
      // ..repeat(reverse: true)
      ;

  late final Animation<T> _animation = widget.tween.animate(_controller);

  @override
  void initState() {
    super.initState();

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.stop(canceled: true);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant NTweenTransition<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.builder != widget.builder) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _animation);
  }
}
