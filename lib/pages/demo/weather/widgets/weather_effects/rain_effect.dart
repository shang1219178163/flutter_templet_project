import 'dart:math';
import 'package:flutter/material.dart';

class RainEffect extends StatefulWidget {
  final double animationSpeed;

  const RainEffect({
    super.key,
    this.animationSpeed = 1.0,
  });

  @override
  State<RainEffect> createState() => _RainEffectState();
}

class _RainEffectState extends State<RainEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<RainDrop> raindrops = [];
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    // 创建雨滴
    for (int i = 0; i < 100; i++) {
      raindrops.add(RainDrop(
        x: random.nextDouble() * 500,
        y: random.nextDouble() * 800 - 800, // 开始在屏幕上方
        length: random.nextDouble() * 15 + 5,
        speed: random.nextDouble() * 12 + 8, // 稍微减慢初始速度
        opacity: random.nextDouble() * 0.6 + 0.3,
      ));
    }
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
        // 更新雨滴位置
        for (var drop in raindrops) {
          // 使用动画速度参数调整雨滴下落速度
          drop.y += drop.speed * widget.animationSpeed;
          if (drop.y > 800) {
            drop.y = random.nextDouble() * -100 - 50; // 重置到顶部
            drop.x = random.nextDouble() * 500;
          }
        }

        return CustomPaint(
          painter: RainPainter(raindrops),
          size: MediaQuery.of(context).size,
        );
      },
    );
  }
}

class RainDrop {
  double x;
  double y;
  double length;
  double speed;
  double opacity;

  RainDrop({
    required this.x,
    required this.y,
    required this.length,
    required this.speed,
    required this.opacity,
  });
}

class RainPainter extends CustomPainter {
  final List<RainDrop> raindrops;

  RainPainter(this.raindrops);

  @override
  void paint(Canvas canvas, Size size) {
    // 绘制底部的水面反射
    final reflectionRect =
        Rect.fromLTWH(0, size.height * 0.85, size.width, size.height * 0.15);
    final reflectionPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.3)],
      ).createShader(reflectionRect);

    canvas.drawRect(reflectionRect, reflectionPaint);

    // 绘制雨滴
    for (var drop in raindrops) {
      final paint = Paint()
        ..color = Colors.white.withOpacity(drop.opacity)
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round;

      // 雨滴主体
      canvas.drawLine(
        Offset(drop.x, drop.y),
        Offset(drop.x, drop.y + drop.length),
        paint,
      );

      // 如果雨滴到达反射区域，绘制反射效果
      if (drop.y + drop.length >= size.height * 0.85) {
        final reflectionPaint = Paint()
          ..color = Colors.white.withOpacity(drop.opacity * 0.5)
          ..strokeWidth = 1.5
          ..strokeCap = StrokeCap.round;

        // 绘制小水花效果
        final splashRadius = 3.0;
        canvas.drawCircle(
          Offset(drop.x, size.height * 0.85),
          splashRadius,
          reflectionPaint..style = PaintingStyle.stroke,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
