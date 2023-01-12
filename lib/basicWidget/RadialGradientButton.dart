//
//  RadialGradientButton.dart
//  flutter_templet_project
//
//  Created by shang on 2023/1/12 22:03.
//  Copyright © 2023/1/12 shang. All rights reserved.
//

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// 雷达渐进色按钮
class RadialGradientButton extends StatefulWidget {

  RadialGradientButton({
    Key? key,
    required this.text,
    // required this.colors,
    // required this.stops,
    this.margin = const EdgeInsets.symmetric(horizontal: 3, vertical: 12),
    this.padding = const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
    this.center = Alignment.center,
    this.onClick,
  }) : super(key: key);

  Text text;
  // List<Color> colors;
  // List<double>? stops;

  EdgeInsetsGeometry? margin;
  EdgeInsetsGeometry? padding;
  Alignment center;
  GestureTapCallback? onClick;

  @override
  _RadialGradientButtonState createState() => _RadialGradientButtonState();
}

class _RadialGradientButtonState extends State<RadialGradientButton> {

  var _scale = 0.5;

  @override
  void initState() {
    SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
      _scale = radiusOfRadialGradient(
          width: context.size?.width,
          height: context.size?.height,
          alignment: widget.center,
      );
      print("context.size:${context.size} ${_scale}");
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onClick,
      child: Container(
        margin: widget.margin,
        padding: widget.padding,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            // tileMode: TileMode.mirror,
            radius: _scale,
            center: widget.center,
            colors: <Color>[
              Colors.red, // blue
              Colors.blue,
              Colors.yellow,
            ],
            stops: const <double>[0.0, 0.5, 0.8],
          ),
        ),
        child: widget.text,
      ),
    );
  }

  /// 获取雷达渐进色 radius
  radiusOfRadialGradient({
    double? width = 0,
    double? height = 0,
    Alignment alignment = Alignment.center,
  }) {
    if(width == null || height == null
        || width == 0 || height == 0) {
      return 0.5;
    }

    final max = math.max(width, height);
    final min = math.min(width, height);
    double scale = max/min;
    if (alignment.x != 0) {
      scale *= 2.0;
    }
    return scale;
  }
}