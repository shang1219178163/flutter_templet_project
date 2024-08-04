//
//  NTransitionBuilder.dart
//  flutter_templet_project
//
//  Created by shang on 2023/10/16 14:14.
//  Copyright © 2023/10/16 shang. All rights reserved.
//

import 'package:flutter/material.dart';

typedef AnimationWidgeBuilder<T> = Widget Function(BuildContext context,
    AnimationController controller, Animation<T> animation);

/// Transition 动画封装
class NTransitionBuilder extends StatefulWidget {
  NTransitionBuilder({
    Key? key,
    this.duration = const Duration(milliseconds: 350),
    required this.builder,
  }) : super(key: key);

  /// 动画时间
  final Duration? duration;

  final AnimationWidgeBuilder<double> builder;

  @override
  _NTransitionBuilderState createState() => _NTransitionBuilderState();
}

class _NTransitionBuilderState extends State<NTransitionBuilder>
    with SingleTickerProviderStateMixin {
  late final _duration = widget.duration ?? Duration(milliseconds: 350);

  late final _controller = AnimationController(
    vsync: this,
    duration: _duration,
    reverseDuration: _duration,
  );

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      startAnimation();
    });
  }

  @override
  void dispose() {
    startAnimation(reverse: true);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _controller, _animation);
  }

  /// 开始动画
  startAnimation({bool reverse = false}) async {
    if (!reverse) {
      await _controller.forward(from: _controller.lowerBound);
    } else {
      await _controller.reverse(from: _controller.upperBound);
    }
  }
}
