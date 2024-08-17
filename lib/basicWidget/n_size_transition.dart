//
//  NSizeTransition.dart
//  flutter_templet_project
//
//  Created by shang on 2023/10/16 12:10.
//  Copyright © 2023/10/16 shang. All rights reserved.
//

import 'package:flutter/material.dart';

/// SizeTransition 动画封装
class NSizeTransition extends StatefulWidget {
  NSizeTransition({
    Key? key,
    this.axis = Axis.vertical,
    this.axisAlignment = 0.0,
    this.duration = const Duration(milliseconds: 350),
    required this.child,
  }) : super(key: key);

  final Axis axis;

  /// -1.0, 0, 1
  final double axisAlignment;

  /// 动画时间
  final Duration? duration;

  final Widget child;

  @override
  _NSizeTransitionState createState() => _NSizeTransitionState();
}

class _NSizeTransitionState extends State<NSizeTransition>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: widget.duration ?? Duration(seconds: 1),
  );

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  @override
  void initState() {
    super.initState();

    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      axisAlignment: widget.axisAlignment,
      sizeFactor: _animation,
      axis: widget.axis,
      child: widget.child,
    );
  }
}
