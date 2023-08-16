import 'dart:ui';

import 'package:flutter/material.dart';


class NDashDecoration extends Decoration {

  NDashDecoration({
    this.gradient,
    this.color,
    this.step = 2,
    this.strokeWidth = 1,
    this.strokeColor = Colors.black,
    this.span = 2,
    this.pointCount = 0,
    this.pointWidth,
    this.radius,
  });
  /// 渐进色
  final Gradient? gradient;

  final Color? color;
  final double step;
  final double span;
  final int pointCount;
  final double? pointWidth;
  final Radius? radius;
  final double strokeWidth;

  final Color? strokeColor;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => _DashBoxPainter(this);
}

class _DashBoxPainter extends BoxPainter {

  _DashBoxPainter(this.decoration);

  final NDashDecoration decoration;


  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    if(configuration.size == null){
      return;
    }

    var radius = decoration.radius ?? Radius.zero;
    canvas.save();
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = decoration.strokeColor ?? Colors.black
      ..strokeWidth = decoration.strokeWidth;
    final path = Path();

    canvas.translate(
      offset.dx + configuration.size!.width / 2,
      offset.dy + configuration.size!.height / 2,
    );

    final zone = Rect.fromCenter(
      center: Offset.zero,
      width: configuration.size!.width,
      height: configuration.size!.height,
    );

    if (decoration.color != null) {
      final rectPaint = Paint()..color = decoration.color!;
      canvas.drawRRect(
          RRect.fromRectAndRadius(zone, radius), rectPaint);
    }

    path.addRRect(RRect.fromRectAndRadius(
      zone,
      radius,
    ));

    if (decoration.gradient != null) {
      paint.shader = decoration.gradient!.createShader(zone);
    }

    _DashPainter(
      span: decoration.span,
      step: decoration.step,
      pointCount: decoration.pointCount,
      pointWidth: decoration.pointWidth,
    ).paint(canvas, path, paint);
    canvas.restore();
  }
}


class _DashPainter {
  const _DashPainter({
    this.step = 2,
    this.span = 2,
    this.pointCount = 0,
    this.pointWidth,
  });

  /// [step] the length of solid line 每段实线长
  final double step;
  /// [span] the space of each solid line  每段空格线长
  final double span;
  /// [pointCount] the point count of dash line  点划线的点数
  final int pointCount;
  /// [pointWidth] the point width of dash line  点划线的点划长
  final double? pointWidth;

  void paint(Canvas canvas, Path path, Paint paint) {
    final pms = path.computeMetrics();
    final pointLineLength = pointWidth ?? paint.strokeWidth;
    final partLength =
        step + span * (pointCount + 1) + pointCount * pointLineLength;

    pms.forEach((PathMetric pm) {
      final count = pm.length ~/ partLength;
      for (var i = 0; i < count; i++) {
        canvas.drawPath(
          pm.extractPath(partLength * i, partLength * i + step), paint,);
        for (var j = 1; j <= pointCount; j++) {
          final start =
              partLength * i + step + span * j + pointLineLength * (j - 1);
          canvas.drawPath(
            pm.extractPath(start, start + pointLineLength),
            paint,
          );
        }
      }
      final tail = pm.length % partLength;
      canvas.drawPath(pm.extractPath(pm.length - tail, pm.length), paint);
    });
  }
}