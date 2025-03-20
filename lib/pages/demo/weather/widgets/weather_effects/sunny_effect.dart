import 'dart:math';
import 'package:flutter/material.dart';

class SunnyEffect extends StatefulWidget {
  final double animationSpeed;

  const SunnyEffect({
    super.key,
    this.animationSpeed = 1.0,
  });

  @override
  State<SunnyEffect> createState() => _SunnyEffectState();
}

class _SunnyEffectState extends State<SunnyEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: SunPainter(_controller.value * widget.animationSpeed),
          size: MediaQuery.of(context).size,
        );
      },
    );
  }
}

class SunPainter extends CustomPainter {
  final double animationValue;

  SunPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width * 0.7;
    final centerY = size.height * 0.3;
    final radius = size.width * 0.2;

    // 绘制太阳光晕
    for (int i = 0; i < 3; i++) {
      final glowRadius = radius + (i * radius * 0.5);
      final paint = Paint()
        ..color = Colors.yellow.withOpacity(0.3 - (i * 0.1))
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(centerX, centerY), glowRadius, paint);
    }

    // 绘制太阳本体
    final sunPaint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(centerX, centerY), radius, sunPaint);

    // 绘制阳光射线
    final rayPaint = Paint()
      ..color = Colors.yellow.withOpacity(0.7)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    // 绘制动态的光线
    final rayCount = 12;
    final angle = 2 * pi / rayCount;

    for (int i = 0; i < rayCount; i++) {
      final rotation = angle * i + (animationValue * pi);
      final rayLength =
          radius * 0.7 * (0.8 + 0.2 * sin(animationValue * 2 * pi + i));

      final startX = centerX + (radius + 5) * cos(rotation);
      final startY = centerY + (radius + 5) * sin(rotation);

      final endX = centerX + (radius + rayLength) * cos(rotation);
      final endY = centerY + (radius + rayLength) * sin(rotation);

      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        rayPaint,
      );
    }

    // 绘制镜头光晕效果
    final lensFlareOpacity = 0.2 + 0.1 * sin(animationValue * 2 * pi);
    final flarePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withOpacity(lensFlareOpacity),
          Colors.white.withOpacity(0),
        ],
      ).createShader(Rect.fromCircle(
        center: Offset(centerX, centerY),
        radius: radius * 2,
      ));

    // 随机位置的光斑
    final flareX = centerX + radius * 0.8 * cos(animationValue * 2 * pi);
    final flareY = centerY + radius * 0.8 * sin(animationValue * 2 * pi);
    canvas.drawCircle(Offset(flareX, flareY), radius * 0.3, flarePaint);
  }

  @override
  bool shouldRepaint(covariant SunPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
