//
//  CirclePulseLoadingWidget.dart
//  flutter_templet_project
//
//  Created by shang on 6/10/21 4:29 PM.
//  Copyright © 6/10/21 shang. All rights reserved.
//

import 'dart:math';

import 'package:flutter/material.dart';

///
/// desc:
///

class CirclePulseLoadingWidget extends StatefulWidget {
  final double radius;
  final BoxShape itemShape;
  final Color itemColor;
  final Duration duration;
  final Curve curve;
  final int count;

  const CirclePulseLoadingWidget(
      {Key? key,
      this.radius = 24,
      this.itemShape = BoxShape.circle,
      this.itemColor = Colors.white,
      this.count = 9,
      this.duration = const Duration(milliseconds: 1000),
      this.curve = Curves.linear})
      : super(key: key);

  @override
  _CirclePulseLoadingWidgetState createState() =>
      _CirclePulseLoadingWidgetState();
}

class _CirclePulseLoadingWidgetState extends State<CirclePulseLoadingWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: widget.duration)..repeat();
  late final Animation<double> _animation =
      _controller.drive(CurveTween(curve: widget.curve));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Flow(
      delegate: _CircleFlow(widget.radius),
      children: List.generate(widget.count, (index) {
        return Center(
          child: ScaleTransition(
            scale: DelayTween(begin: 0.0, end: 1.0, delay: index * .1)
                .animate(_animation),
            child: SizedBox(
              width: 10,
              height: 10,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: widget.itemShape,
                  color: widget.itemColor,
                  // border: Border.all(
                  // color: _ballStyle.borderColor, width: _ballStyle.borderWidth)
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _CircleFlow extends FlowDelegate {
  final double radius;

  _CircleFlow(this.radius);

  @override
  void paintChildren(FlowPaintingContext context) {
    var x = 0.0; //开始(0,0)在父组件的中心
    var y = 0.0;
    for (var i = 0; i < context.childCount; i++) {
      x = radius * cos(i * 2 * pi / (context.childCount - 1)); //根据数学得出坐标
      y = radius * sin(i * 2 * pi / (context.childCount - 1)); //根据数学得出坐标
      context.paintChild(i, transform: Matrix4.translationValues(x, y, 0));
    }
  }

  @override
  bool shouldRepaint(FlowDelegate oldDelegate) => true;
}

///
/// desc:
///
class DelayTween extends Tween<double> {
  final double delay;

  DelayTween({required double begin, required double end, required this.delay})
      : super(begin: begin, end: end);

  @override
  double lerp(double t) {
    return super.lerp((sin((t - delay) * 2 * pi) + 1) / 2);
  }

  @override
  double evaluate(Animation<double> animation) => lerp(animation.value);
}
