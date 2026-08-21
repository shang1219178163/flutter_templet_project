import 'dart:math';

import 'package:flutter/material.dart';

class NAnimatedStepLineIndicator extends StatelessWidget {
  final double currentIndex;
  final int count;
  final Duration duration;
  final double height;

  final double itemWidth;
  final double spacing;

  final Color color;

  static const double _kMinHeight = 18;

  const NAnimatedStepLineIndicator({
    super.key,
    required this.currentIndex,
    required this.count,
    this.duration = const Duration(milliseconds: 300),
    this.height = 18,
    required this.itemWidth,
    required this.spacing,
    this.color = const Color(0xFFFF1236),
  });

  @override
  Widget build(BuildContext context) {
    final resolvedHeight = max(height, _kMinHeight);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: currentIndex),
      duration: duration,
      builder: (_, value, __) {
        return SizedBox(
          width: double.infinity,
          height: resolvedHeight,
          child: CustomPaint(
            painter: _StepIndicatorPainter(
              currentIndex: value,
              count: count,
              itemWidth: itemWidth,
              spacing: spacing,
              color: color,
            ),
          ),
        );
      },
    );
  }
}

class _StepIndicatorPainter extends CustomPainter {
  final double currentIndex;
  final int count;
  final double itemWidth;
  final double spacing;
  final Color color;

  _StepIndicatorPainter({
    required this.currentIndex,
    required this.count,
    required this.itemWidth,
    required this.spacing,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height / 2;

    // final itemWidth = size.width / count;
    final centerX = itemWidth / 2 + currentIndex * (itemWidth + spacing);

    final bendStartX = centerX - 10;
    final bendEndX = centerX + 10;

    // 左侧
    final leftRect = Rect.fromPoints(
      Offset(0, y),
      Offset(bendStartX, y),
    );
    final leftPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.white, color],
      ).createShader(leftRect)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final paintRed = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(0, y),
      Offset(bendStartX, y),
      leftPaint,
    );

    // 中间曲线
    const r = 2.0;
    final path = Path()
      ..moveTo(bendStartX, y)
      ..lineTo(centerX - r, y + 7 - r)
      ..conicTo(
        centerX,
        y + 7,
        centerX + r,
        y + 7 - r,
        0.6,
      )
      ..lineTo(bendEndX, y);

    canvas.drawPath(path, paintRed);

    // 右侧
    final rightRect = Rect.fromPoints(
      Offset(bendEndX, y),
      Offset(size.width, y),
    );
    final rightPaint = Paint()
      ..shader = LinearGradient(
        colors: [color, Colors.white],
      ).createShader(rightRect)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(bendEndX, y),
      Offset(size.width, y),
      rightPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _StepIndicatorPainter oldDelegate) {
    return oldDelegate.currentIndex != currentIndex || oldDelegate.count != count;
  }
}
