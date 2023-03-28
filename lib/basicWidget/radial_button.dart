//
//  radial_button.dart
//  flutter_templet_project
//
//  Created by shang on 2023/1/12 22:03.
//  Copyright © 2023/1/12 shang. All rights reserved.
//

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_templet_project/extension/alignment_ext.dart';

/// 雷达渐进色按钮
class RadialButton extends StatefulWidget {

  RadialButton({
    Key? key,
    required this.text,
    required this.onTap,
    // required this.colors,
    // required this.stops,
    this.margin = const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
    this.padding = const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
    this.center = Alignment.center,
  }) : super(key: key);

  Text text;
  // List<Color> colors;
  // List<double>? stops;

  EdgeInsets? margin;
  EdgeInsets? padding;
  Alignment center;
  GestureTapCallback? onTap;

  @override
  _RadialButtonState createState() => _RadialButtonState();
}

class _RadialButtonState extends State<RadialButton> {

  var _scale = 0.5;

  Size? _currentSize;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (context.size?.width == null || context.size?.height == null) {
        return;
      }
      _currentSize = context.size;

      double w = context.size!.width;
      double h = context.size!.height;
      // _scale = radiusOfRadialGradient(
      //     width: w,
      //     height: h,
      //     alignment: widget.center,
      // );
      _scale = widget.center.radiusOfRadialGradient(
        width: w,
        height: h,
        isGreed: true,
      ) ?? 0.5;
      print("context.size:${context.size} ${_scale}");
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        margin: widget.margin,
        padding: widget.padding,
        decoration: BoxDecoration(
          gradient: _currentSize == null ? null : RadialGradient(
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
  double radiusOfRadialGradient({
    double? width = 0,
    double? height = 0,
    Alignment alignment = Alignment.center,
    bool isGreed = true,
    double defaultValue = 0.5,
  }) {
    if(width == null || height == null
        || width <= 0 || height <= 0) {
      return defaultValue;
    }

    final max = math.max(width, height);
    final min = math.min(width, height);
    double result = max/min;
    if (alignment.x != 0) {
      result *= 2.0;
    }
    return result;
  }
}

